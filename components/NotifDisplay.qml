import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import qs.data

GlassContainer {
    id: root
    required property Notification notif

    content: Item {
        implicitWidth: notifContent.implicitWidth
        implicitHeight: notifContent.implicitHeight

        ColumnLayout {
            id: notifContent
            anchors.fill: parent
            spacing: 0

            AppPill {
                Layout.bottomMargin: Sizing.sizeMicro
                appName: root.notif.appName
                appIcon: root.notif.appIcon
            }

            StyleText {
                Layout.bottomMargin: Sizing.sizeXS
                text: root.notif.summary
                font.pixelSize: Sizing.sizeL
                bold: true
            }

            StyleText {
                text: root.notif.body
            }
        }

        RowLayout {
            anchors.top: parent.top
            anchors.right: parent.right

            IconButton {
                iconName: "close"
                iconSize: Sizing.sizeL

                onTapped: root.notif.dismiss()
            }
        }
    }
}
