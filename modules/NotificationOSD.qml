import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Notifications
import Quickshell.Wayland
import qs.components
import qs.data
import qs.services

PanelWindow {
    id: root

    required property ShellScreen currentScreen
    screen: currentScreen

    readonly property string screenName: currentScreen?.name ?? ""

    Connections {
        target: Hyprland

        function onRawEvent(event: HyprlandEvent): void {
            if (event.name == "monitorremoved" && event.data == root.screenName)
            alertRepeater.model = [];
        }
    }

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

    property var alerts: []

    ScriptModel {
        id: alertModel
        values: root.alerts
    }

    function addAlert(notification: Notification): void {
        root.alerts = [...root.alerts, notification];
    }

    function removeAlert(id: int): void {
        root.alerts = root.alerts.filter((v, i) => v.id != id);
    }

    ColumnLayout {
        id: notifColumn

        anchors.top: parent.top
        anchors.right: parent.right
        width: parent.width - anchors.rightMargin
        anchors.topMargin: Sizing.sizeXXS
        anchors.rightMargin: Sizing.sizeXXS

        spacing: Sizing.sizeXXS

        visible: !Hypr.getMonitor(root.screen)?.controlCenter?.open

        Repeater {
            id: alertRepeater
            model: alertModel

            NotifDisplay {
                required property Notification modelData

                Layout.fillWidth: true
                notif: modelData

                onFinished: root.removeAlert(modelData.id)

                Timer {
                    interval: 3000
                    running: true
                    onTriggered: parent.close()
                }
            }
        }
    }

    Connections {
        target: Notifs

        function onNotificationAlert(notification: Notification): void {
            root.addAlert(notification);
        }
    }
}
