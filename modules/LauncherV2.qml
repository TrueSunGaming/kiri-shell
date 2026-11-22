import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import qs.components
import qs.data
import qs.services
import "../util/fuzzySearch.js" as Fuzzy

PanelWindow {
    id: root

    required property ShellScreen currentScreen
    screen: currentScreen

    property bool open: false
    property real animProgress: open ? 1 : 0
    property int selectedIndex: 0
    property var entries: []
    property var items: []
    readonly property Component launcherItemComponent: LauncherItem {}

    Timer {
        id: rebuildTimer

        interval: 0
        onTriggered: {
            root.refreshEntries();
            root.rebuildList();
        }
    }

    onSelectedIndexChanged: {
        const item = root.items[root.selectedIndex];
        if (!item) return;
        const top = item.y;
        const bottom = item.y + item.height;
        if (top < appList.contentY) appList.contentY = top;
        else if (bottom > appList.contentY + appList.height) appList.contentY = bottom - appList.height;
    }

    onOpenChanged: {
        if (open) {
            searchBox.text = "";
            appList.contentY = 0;
            searchBox.focus = true;
            selectedIndex = 0;
            rebuildTimer.restart();
        } else {
            rebuildTimer.stop();
            clearItems();
        }
    }

    Behavior on animProgress {
        Spring {}
    }

    function openEntry(entry: DesktopEntry): void {
        if (!entry) return;
        Quickshell.execDetached({ command: entry.command, workingDirectory: Quickshell.env("HOME") });
        root.open = false;
    }

    function refreshEntries(): void {
        root.entries = Fuzzy.fuzzySearch(DesktopEntries.applications.values, searchBox.text, app => app.name);
    }

    function clearItems(): void {
        for (const item of root.items) item.destroy();
        root.items = [];
    }

    function rebuildList(): void {
        if (!appColumn) return;
        clearItems();
        for (let i = 0; i < root.entries.length; i++) {
            const result = root.entries[i];
            const item = root.launcherItemComponent.createObject(appColumn, {
                index: i,
                name: Fuzzy.toRichText(result, Colors.toHex(Colors.accent)),
                description: result.item.comment,
                icon: result.item.icon
            });
            if (item) root.items.push(item);
        }
    }

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    exclusionMode: ExclusionMode.Ignore
    mask: Region {
        item: root.open ? launcher : null
    }
    focusable: root.open
    WlrLayershell.layer: WlrLayer.Overlay

    HyprlandFocusGrab {
        windows: [root]
        active: root.open
        onCleared: root.open = false
    }

    color: "transparent"
    surfaceFormat.opaque: false

    GlassRectangle {
        id: launcher

        implicitWidth: Sizing.relative(screen.width, -1.5)
        implicitHeight: implicitWidth * screen.height / screen.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top

        readonly property real startMargin: parent.height
        readonly property real endMargin: parent.height / 2 - height / 2

        anchors.topMargin: startMargin + root.animProgress * (endMargin - startMargin)

        transform: FlexScaleMatrix {
            rectWidth: launcher.width
            rectHeight: launcher.height
            topScale: root.animProgress
            bottomScale: 0.5 + root.animProgress / 2
        }

        opacity: root.animProgress
        radius: Sizing.sizeM

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Sizing.sizeM

            spacing: 0

            StyleTextField {
                id: searchBox

                Layout.fillWidth: true
                font.pixelSize: Sizing.sizeXL
                error: root.entries.length == 0

                onTextChanged: {
                    root.selectedIndex = 0;
                    if (root.open) rebuildTimer.restart();
                }

                Keys.onEscapePressed: root.open = false
                Keys.onUpPressed: {
                    if (root.entries.length == 0) return;
                    if (root.selectedIndex > 0) root.selectedIndex--;
                    else root.selectedIndex = root.entries.length - 1;
                }
                Keys.onDownPressed: {
                    if (root.entries.length == 0) return;
                    if (root.selectedIndex < root.entries.length - 1) root.selectedIndex++;
                    else root.selectedIndex = 0;
                }
                Keys.onReturnPressed: root.openEntry(root.entries[root.selectedIndex].item)
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                Layout.topMargin: Sizing.sizeMicro
                Layout.bottomMargin: Sizing.sizeM
                color: Colors.glassBorder
            }

            Flickable {
                id: appList

                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                contentWidth: width
                contentHeight: appColumn.implicitHeight

                ColumnLayout {
                    id: appColumn

                    width: parent.width
                    spacing: Sizing.sizeXXS
                }
            }
        }
    }

    component LauncherItem: GlassContainer {
        id: launcherItem

        required property int index
        required property string name
        property string description
        property url icon
        readonly property bool selected: root.selectedIndex == index

        Layout.fillWidth: true

        color: Colors.subShield
        padding: Sizing.sizeM

        content: RowLayout {
            spacing: Sizing.sizeXXS

            IconImage {
                Layout.preferredWidth: implicitSize
                Layout.fillHeight: false
                Layout.alignment: Qt.AlignTop

                readonly property string icon: Quickshell.iconPath(launcherItem.icon, true)

                source: icon
                implicitSize: Sizing.sizeXL
                asynchronous: true
            }

            ColumnLayout {
                StyleText {
                    Layout.fillWidth: true
                    Layout.horizontalStretchFactor: 1
                    Layout.preferredWidth: 0
                    text: launcherItem.name
                    font.pixelSize: Sizing.sizeL
                    bold: launcherItem.selected
                    elide: Text.ElideRight
                }

                StyleText {
                    Layout.fillWidth: true
                    Layout.horizontalStretchFactor: 1
                    Layout.preferredWidth: 0
                    text: launcherItem.description
                    color: Colors.secondaryText
                    italic: true
                    elide: Text.ElideRight
                    visible: text != ""
                }
            }
        }
    }
}
