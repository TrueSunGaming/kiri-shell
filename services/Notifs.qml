pragma Singleton

import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    signal notification(notification: Notification)
    signal notificationAlert(notification: Notification)

    readonly property ObjectModel notifications: notifs.trackedNotifications

    property bool silenced: false

    readonly property int notifCount: notifications.values.length
    readonly property string notifIcon: {
        if (silenced) return "notifications_off";
        if (notifCount > 0) return "notifications_unread";
        return "notifications";
    }

    function sendNotification(notif: Notification): void {
        notif.tracked = true;
        notification(notif);
        if (notif.lastGeneration) return;
        if (!silenced) notificationAlert(notif);
    }

    NotificationServer {
        id: notifs

        keepOnReload: true
        bodyMarkupSupported: true
        persistenceSupported: true

        onNotification: (n) => root.sendNotification(n)
    }
}
