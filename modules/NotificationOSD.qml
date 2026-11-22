import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland
import qs.components
import qs.data
import qs.services

PanelWindow {
    id: root

    required property ShellScreen currentScreen
    screen: currentScreen

    anchors {
        top: true
        right: true
        bottom: true
    }
    implicitWidth: Sizing.notificationWidth + Sizing.sizeXXS + 2
    exclusiveZone: 0

    color: "transparent"
    surfaceFormat.opaque: false

    mask: Region {}

    ColumnLayout {
        id: notifColumn

        anchors.top: parent.top
        anchors.right: parent.right
        width: parent.width - anchors.rightMargin
        anchors.topMargin: Sizing.sizeXXS
        anchors.rightMargin: Sizing.sizeXXS

        spacing: Sizing.sizeXXS

        visible: !Hypr.getMonitor(root.screen)?.controlCenter?.open
    }

    Connections {
        target: Notifs

        function onNotificationAlert(notification: Notification): void {
            notifAlert.createObject(notifColumn, { "notif": notification });
        }
    }

    function clearAlerts(): void {
        const alerts = [...notifColumn.children];
        for (const alert of alerts)
        alert.destroy();
    }

    Component.onDestruction: clearAlerts()

    Component {
        id: notifAlert

        NotifDisplay {
            id: alertDisplay
            Layout.fillWidth: true
            destructible: true

            Timer {
                interval: 3000
                running: true
                onTriggered: alertDisplay.close()
            }
        }
    }
}
