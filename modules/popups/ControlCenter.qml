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

            delegate: GlassContainer {
                id: notif

                required property Notification modelData

                Layout.fillWidth: true

                content: Item {
                    implicitWidth: notifContent.implicitWidth
                    implicitHeight: notifContent.implicitHeight

                    ColumnLayout {
                        id: notifContent
                        anchors.fill: parent
                        spacing: 0

                        AppPill {
                            Layout.bottomMargin: Sizing.sizeMicro
                            appName: notif.modelData.appName
                            appIcon: notif.modelData.appIcon
                        }

                        StyleText {
                            Layout.bottomMargin: Sizing.sizeXS
                            text: notif.modelData.summary
                            font.pixelSize: Sizing.sizeL
                            bold: true
                        }

                        StyleText {
                            text: notif.modelData.body
                        }
                    }

                    RowLayout {
                        anchors.top: parent.top
                        anchors.right: parent.right

                        IconButton {
                            iconName: "close"
                            iconSize: Sizing.sizeL

                            onTapped: notif.modelData.dismiss()
                        }
                    }
                }
            }
        }
    }

    contentContainer: content
}
