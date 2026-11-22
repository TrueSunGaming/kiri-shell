import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import qs.components
import qs.data
import qs.services
import qs.util

MenuBarPopup {
    id: root

    implicitHeight: screen.height - Sizing.barSize - Sizing.sizeMicro

    property real animProgress: open ? 1 : 0

    Behavior on animProgress {
        Spring {}
    }

    visible: animProgress > 0

    ColumnLayout {
        id: content

        anchors.fill: parent
        anchors.topMargin: Sizing.sizeXXS
        implicitWidth: mainContainer.implicitWidth

        opacity: root.animProgress

        transform: MorphAnimation {
            item: content
            animProgress: root.animProgress
        }

        spacing: Sizing.sizeXXS

        GlassContainer {
            id: mainContainer
            implicitWidth: Sizing.notificationWidth
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            clip: true
            spacing: Sizing.sizeXXS

            model: Notifs.notifications

            delegate: NotifDisplay {
                required property Notification modelData
                notif: modelData
                implicitWidth: mainContainer.implicitWidth
            }

            Component.onDestruction: model = undefined
        }
    }

    contentContainer: content

    property MonitorData lastMonitor: null

    function addToMonitor(): void {
        if (lastMonitor?.controlCenter == this) lastMonitor.controlCenter = null;
        lastMonitor = null;

        const monitor = Hypr.getMonitor(screen);
        if (!monitor) return;
        monitor.controlCenter = this;
        lastMonitor = monitor;
    }

    function detachFromMonitor(): void {
        if (lastMonitor?.controlCenter == this) lastMonitor.controlCenter = null;
        lastMonitor = null;
    }

    onScreenChanged: addToMonitor()
    Component.onCompleted: addToMonitor()
    Component.onDestruction: detachFromMonitor()
}
