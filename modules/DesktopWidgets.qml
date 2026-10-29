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

    property bool desktopShown: Hyprland.monitorFor(screen)?.activeWorkspace?.toplevels.values.length == 0 ?? true

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
        visible: root.desktopShown

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
