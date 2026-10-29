pragma Singleton

import Quickshell

Singleton {
    SystemClock {
        id: clock
    }

    readonly property date date: clock.date ?? new Date()
    readonly property string long12hr: Qt.formatDateTime(date, "h:mm:ss AP")
    readonly property string short12hr: Qt.formatDateTime(date, "h:mm AP")
    readonly property string longDate: Qt.formatDateTime(date, "dddd, MMMM d")
    // readonly property string longDate: "Wednesday, September 30"
    readonly property string shortDate: Qt.formatDateTime(date, "ddd, MMM d")
}
