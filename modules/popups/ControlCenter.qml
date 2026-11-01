import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import qs.components
import qs.data
import qs.services

MenuBarPopup {
    id: root

    property real animProgress: open ? 1 : 0

    Behavior on animProgress {
        Spring {}
    }

    visible: animProgress > 0

    ColumnLayout {
        id: content

        anchors.top: parent.top
        anchors.topMargin: Sizing.sizeXXS
        anchors.horizontalCenter: parent.horizontalCenter

        opacity: root.animProgress

        transform: MorphAnimation {
            item: content
            animProgress: root.animProgress
        }

        spacing: Sizing.sizeXXS

        GlassContainer {

        }

        Repeater {
            model: Notifs.notifications

            delegate: NotifDisplay {
                required property Notification modelData

                Layout.fillWidth: true
                notif: modelData

                open: false
                Component.onCompleted: open = true

                Behavior on y {
                    Spring {}
                }
            }
        }
    }

    contentContainer: content
}
