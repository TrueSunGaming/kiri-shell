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

PanelWindow {
    id: root

    required property ShellScreen currentScreen
    screen: currentScreen

    property bool desktopShown: Hypr.getMonitor(screen)?.floatingOnly
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

        ClockWidget {
            id: clock
        }

        ColumnLayout {
            anchors.horizontalCenter: clock.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            MediaWidget {}
        }
    }
}
