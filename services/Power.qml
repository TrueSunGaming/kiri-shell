pragma Singleton

import Quickshell
import Quickshell.Services.UPower

Singleton {
    readonly property bool showBattery: UPower.displayDevice.isLaptopBattery
    readonly property bool charging: UPower.displayDevice.changeRate > 0
    readonly property real percentage: UPower.displayDevice.percentage * 100

    readonly property list<int> levels: [0, 20, 30, 50, 60, 80, 90, 100]
    readonly property int batteryLevel: {
        for (let i = 0; i < levels.length; i++) {
            if (percentage <= levels[i])
            return levels[i];
        }
        return levels[0];
    }

    readonly property string batteryIcon: `battery_${batteryLevel}${charging ? "_charging" : ""}`
}
