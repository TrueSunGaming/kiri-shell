import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Shapes
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

    onSelectedIndexChanged: appList.positionViewAtIndex(selectedIndex, ListView.Contain)

    onOpenChanged: {
        if (open) {
            searchBox.text = "";
            appList.positionViewAtBeginning();
            searchBox.focus = true;
            selectedIndex = 0;
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

        visible: root.animProgress > 0

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
        radius: Sizing.sizeXXL

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Sizing.sizeXXL
            spacing: Sizing.sizeM

            StyleTextField {
                id: searchBox
                Layout.fillWidth: true
                font.pixelSize: Sizing.sizeXXL
                padding: 0
                background: null
                error: appList.model.values.length == 0

                onTextChanged: root.selectedIndex = 0;

                Keys.onEscapePressed: root.open = false
                Keys.onUpPressed: {
                    if (appList.model.values.length == 0) return;
                    if (root.selectedIndex > 0) root.selectedIndex--;
                    else root.selectedIndex = appList.model.values.length - 1;
                }
                Keys.onDownPressed: {
                    if (appList.model.values.length == 0) return;
                    if (root.selectedIndex < appList.model.values.length - 1) root.selectedIndex++;
                    else root.selectedIndex = 0;
                }
                Keys.onReturnPressed: root.openEntry(appList.model.values[root.selectedIndex].item)
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Colors.secondaryText
            }

            ListView {
                id: appList

                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                spacing: Sizing.sizeXXS

                model: ScriptModel {
                    values: {
                        return Fuzzy.fuzzySearch(DesktopEntries.applications.values, searchBox.text, app => app.name);
                    }

                    // FIXME: setting this makes the indices not update when search updates
                    // objectProp: "text"
                }

                delegate: ListItem {
                    id: appDelegate

                    required property var modelData
                    required property int index

                    implicitWidth: appList.width
                    selectable: true
                    selected: root.selectedIndex == index

                    onTapped: root.openEntry(modelData.item)

                    RowLayout {
                        spacing: Sizing.sizeXXS

                        IconImage {
                            Layout.preferredWidth: implicitSize

                            readonly property string icon: Quickshell.iconPath(appDelegate.modelData.item.icon, true)

                            source: icon
                            implicitSize: (appDelegate.height - appDelegate.margin * 2)
                            asynchronous: true
                            Layout.alignment: Qt.AlignVCenter
                        }

                        StyleText {
                            Layout.fillWidth: true
                            Layout.horizontalStretchFactor: 1
                            Layout.preferredWidth: 0
                            text: Fuzzy.toRichText(appDelegate.modelData, Colors.toHex(Colors.accent))
                            font.pixelSize: Sizing.sizeL
                            bold: appDelegate.selected
                            elide: Text.ElideRight
                        }

                        StyleText {
                            Layout.fillWidth: true
                            Layout.horizontalStretchFactor: 1
                            Layout.preferredWidth: 0
                            text: appDelegate.modelData.item.comment
                            font.pixelSize: Sizing.sizeM
                            italic: true
                            opacity: 0.5
                            horizontalAlignment: Text.AlignRight
                            elide: Text.ElideRight
                        }
                    }
                }
            }
        }
    }
}
