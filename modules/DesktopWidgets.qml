import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Mpris
import Quickshell.Wayland
import Quickshell.Widgets
import qs.components
import qs.data
import qs.modules.widgets
import qs.services
import qs.util

PanelWindow {
    id: root

    required property ShellScreen currentScreen
    screen: currentScreen

    property bool desktopShown: Hypr.getMonitor(screen)?.floatingOnly ?? true
    property real animProgress: desktopShown ? 1 : 0

    Behavior on animProgress {
        Spring {}
    }

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    WlrLayershell.layer: WlrLayer.Background

    color: "transparent"
    surfaceFormat.opaque: false

    Item {
        anchors.fill: parent
        anchors.margins: Sizing.sizeXXL
        visible: root.animProgress > 0
        opacity: root.animProgress

        WidgetGrid {
            id: grid
            anchors.fill: parent

            items: [
            GridItem {
                row: 0
                column: 0
                columnSpan: 7
                rowSpan: 4
                item: MediaWidget {}
            },
            GridItem {
                row: 2
                column: 9
                columnSpan: 10
                rowSpan: 3
                item: MediaWidget {}
            }
            ]
        }

        TapHandler {
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onTapped: console.log("hi")
        }
    }
}
