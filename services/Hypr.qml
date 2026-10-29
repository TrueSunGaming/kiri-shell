pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.util

Singleton {
    id: root
    property list<MonitorData> monitors

    Variants {
        model: Quickshell.screens

        delegate: MonitorData {
            required property ShellScreen modelData
            screen: modelData

            Component.onCompleted: root.monitors.push(this)
            Component.onDestruction: root.monitors.splice(root.monitors.indexOf(this), 1)
        }
    }

    Connections {
        target: Hyprland

        function onRawEvent(event: HyprlandEvent): void {
            if (event.name == "changefloatingmode") Hyprland.refreshToplevels();
        }
    }

    function getMonitor(screen: ShellScreen): MonitorData {
        return monitors.find((md) => md.screen == screen);
    }

    readonly property int maxWorkspace: Hyprland.workspaces.values.reduce((t, v) => Math.max(t, v.id), -1)
    readonly property int newWorkspace: maxWorkspace + 1

    function focusWorkspace(workspace: int): void {
        Hyprland.dispatch(`hl.dsp.focus({ workspace = ${workspace} })`);
    }

    function focusNewWorkspace(): void {
        focusWorkspace(newWorkspace);
    }
}
