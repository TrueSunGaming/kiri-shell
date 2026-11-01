import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Services.SystemTray
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import qs.components
import qs.data
import qs.modules.popups
import qs.services
import qs.util

PanelWindow {
    id: root

    required property ShellScreen currentScreen
    screen: currentScreen

    readonly property MonitorData monitor: Hypr.getMonitor(screen)

    property MenuBarItem selectedItem: null
    property list<MenuBarPopup> openPopups: []

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: Sizing.barSize
    WlrLayershell.layer: openPopups.length > 0 ? WlrLayer.Overlay : WlrLayer.Top
    WlrLayershell.namespace: "quickshell-xray"

    Shortcut {
        enabled: root.selectedItem != null
        sequences: [StandardKey.Cancel]
        onActivated: root.selectedItem = null
    }

    color: Colors.shield
    surfaceFormat.opaque: false

    Rectangle {
        anchors.fill: parent

        color: "transparent"

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            implicitHeight: 1
            color: Colors.glassBorder
        }

        Item {
            anchors.fill: parent

            RowLayout {
                anchors.left: parent.left
                anchors.leftMargin: Sizing.sizeMicro
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                spacing: 0

                RowLayout {
                    visible: root.monitor.activeToplevel.toplevel != null
                    spacing: 0

                    MenuBarItem {
                        tappable: true
                        onTapped: root.monitor.activeToplevel.close()

                        tooltip: "Close"

                        MaterialIcon {
                            iconName: "close"
                        }
                    }

                    MenuBarItem {
                        tappable: true
                        onTapped: root.monitor.activeToplevel.toggleFloating()

                        tooltip: root.monitor.activeToplevel.floating ? "Make tiling" : "Make floating"

                        MaterialIcon {
                            iconName: root.monitor.activeToplevel.floating ? "float_off" : "float_on"
                        }
                    }

                    MenuBarItem {
                        tappable: true
                        onTapped: Hypr.focusNewWorkspace()

                        tooltip: "New workspace"

                        MaterialIcon {
                            iconName: "new_workspace"
                        }
                    }

                    MenuBarItem {
                        visible: !root.monitor.activeToplevel.isolated
                        tappable: true
                        onTapped: root.monitor.activeToplevel.moveToNewWorkspace()

                        tooltip: "Isolate"

                        MaterialIcon {
                            iconName: "isolate"
                        }
                    }

                    MenuBarItem {
                        Layout.leftMargin: Sizing.sizeMicro

                        id: activeAppItem

                        RowLayout {
                            spacing: Sizing.sizeMicro

                            IconImage {
                                source: root.monitor.activeToplevel.icon
                                visible: source != ""
                                Layout.fillHeight: true
                                Layout.preferredWidth: height
                            }

                            StyleText {
                                Layout.fillHeight: true
                                Layout.preferredWidth: Sizing.relative(Sizing.fontSize, 7)
                                text: root.monitor.activeToplevel.toplevel?.title ?? ""
                                bold: true
                                elide: Text.ElideMiddle
                            }
                        }
                    }
                }
            }

            RowLayout {
                anchors.right: parent.right
                anchors.rightMargin: Sizing.sizeMicro
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                spacing: 0

                Repeater {
                    model: SystemTray.items

                    delegate: MenuBarItem {
                        id: systemTrayItem

                        required property SystemTrayItem modelData

                        tooltip: modelData.title || modelData.tooltipDescription

                        tappable: modelData.hasMenu
                        onTapped: {
                            modelData.activate();
                            menuAnchor.open();
                        }

                        IconImage {
                            id: trayIcon
                            source: systemTrayItem.modelData.icon
                            implicitSize: Sizing.sizeL

                            QsMenuAnchor {
                                id: menuAnchor
                                menu: systemTrayItem.modelData.menu
                                anchor.item: trayIcon
                                anchor.edges: Edges.Bottom | Edges.Left
                            }
                        }
                    }
                }

                MenuBarItem {
                    id: volumeBarItem

                    selectable: true

                    tooltip: `${Audio.sinkName} (${Audio.volume}%)`

                    onTapped: {
                        if (!selected) return;
                        if (!popup.osdActive) return;
                        root.selectedItem = null;
                        popup.osdActive = false;
                    }

                    MaterialIcon {
                        iconName: Audio.icon
                    }

                    popup: VolumeOSD {
                        menuBar: root
                        menuBarItem: volumeBarItem
                        open: volumeBarItem.selected || osdActive
                        grabFocus: volumeBarItem.selected
                    }
                }

                MenuBarItem {
                    id: mediaItem

                    selectable: true

                    readonly property int playerCount: Media.playerModel.values.length
                    tooltip: `${playerCount} player${playerCount != 1 ? "s" : ""}`

                    MaterialIcon {
                        iconName: "media"
                    }

                    popup: MediaControls {
                        id: mediaControls
                        menuBar: root
                        menuBarItem: mediaItem
                        open: mediaItem.selected
                    }
                }

                MenuBarItem {
                    tooltip: Wifi.statusText

                    MaterialIcon {
                        iconName: "wifi"
                    }
                }

                MenuBarItem {
                    visible: Power.showBattery

                    tooltip: `${Power.percentage}% (${Power.charging ? "plugged in" : "on battery"})`

                    RowLayout {
                        spacing: Sizing.sizeMicro

                        MaterialIcon {
                            iconName: Power.batteryIcon
                        }

                        StyleText {
                            id: batteryPercentage

                            visible: Power.percentage < 100 || !Power.charging
                            text: `${Power.percentage}%`
                        }
                    }
                }

                MenuBarItem {
                    StyleText {
                        text: Clock.shortDate
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                MenuBarItem {
                    id: clockBarItem

                    selectable: true

                    StyleText {
                        text: Clock.long12hr
                        verticalAlignment: Text.AlignVCenter
                        bold: true
                    }

                    popup: MenuBarPopup {
                        menuBar: root
                        menuBarItem: clockBarItem
                        open: clockBarItem.selected
                    }
                }
            }
        }

        TapHandler {
            onTapped: root.selectedItem = null;
        }
    }

    component MenuBarItem: WrapperRectangle {
        id: menuBarItem

        signal tapped

        property bool selectable: false
        property bool tappable: false
        property string tooltip: ""
        property MenuBarPopup popup: null
        readonly property bool selected: root.selectedItem == this
        readonly property bool popupOpen: popup?.open ?? false
        property real bgOpacity: selected || popupOpen ? 0.18 : hoverHandler.hovered ? 0.12 : 0

        onPopupOpenChanged: {
            if (!popupOpen) {
                const index = root.openPopups.indexOf(popup);
                if (!index != -1) root.openPopups.splice(index, 1);
                return;
            }

            if (!root.openPopups.includes(popup)) root.openPopups.push(popup);
        }

        function deselect(): void {
            if (root.selectedItem == this) root.selectedItem = null;
        }

        Behavior on bgOpacity {
            Spring {
                damping: 1
            }
        }

        color: Qt.alpha(Colors.accent, bgOpacity)
        leftMargin: Sizing.sizeXXS
        rightMargin: leftMargin
        radius: leftMargin

        HoverHandler {
            id: hoverHandler
            enabled: menuBarItem.selectable || menuBarItem.tappable || menuBarItem.tooltip
        }

        TapHandler {
            enabled: menuBarItem.selectable || menuBarItem.tappable
            gesturePolicy: TapHandler.ReleaseWithinBounds
            onTapped: {
                if (root.selectedItem == menuBarItem) {
                    root.selectedItem = null;
                    return;
                }

                if (menuBarItem.selectable) root.selectedItem = menuBarItem;

                menuBarItem.tapped();
            }
        }

        ToolTipWindow {
            anchorItem: menuBarItem
            open: hoverHandler.hovered && !menuBarItem.popup?.open && menuBarItem.tooltip
            text: menuBarItem.tooltip
        }
    }
}
