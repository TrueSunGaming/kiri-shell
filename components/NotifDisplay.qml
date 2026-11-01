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
                Layout.maximumWidth: Sizing.relative(parent.width, -0.5)
                Layout.bottomMargin: Sizing.sizeMicro
                appName: root.notif.appName
                appIcon: root.notif.appIcon
                text.elide: Text.ElideRight
            }

            StyleText {
                Layout.fillWidth: true
                Layout.bottomMargin: Sizing.sizeXS
                text: root.notif.summary
                font.pixelSize: Sizing.sizeL
                bold: true
                wrapMode: Text.Wrap
            }

            StyleText {
                Layout.fillWidth: true
                text: root.notif.body
                wrapMode: Text.Wrap
            }
        }

        IconButton {
            anchors.top: parent.top
            anchors.right: parent.right

            iconName: "close"
            iconSize: Sizing.sizeL

            onTapped: root.notif.dismiss()
        }
    }
}
