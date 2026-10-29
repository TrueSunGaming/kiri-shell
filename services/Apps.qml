pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
    id: root

    Connections {
        id: desktopWatcher

        property bool bindToggle: false
        target: DesktopEntries

        function onApplicationsChanged() {
            bindToggle = !bindToggle;
        }
    }

    function heuristicLookup(name: string): DesktopEntry {
        if (!name) return null;

        void desktopWatcher.bindToggle;

        const heuristicResult = DesktopEntries.heuristicLookup(name);
        if (heuristicResult) return heuristicResult;

        return DesktopEntries.applications.values.find((entry) => entry.id.toLowerCase().includes(name.toLowerCase()));
    }

    function getAppIconEntry(appId: string): string {
        return heuristicLookup(appId)?.icon ?? "";
    }

    function getAppIcon(appId: string): string {
        const appName = getAppIconEntry(appId) || appId;
        return Quickshell.iconPath(appName, true) || Quickshell.iconPath(appName.toLowerCase(), true) || "";
    }

    function getToplevelAppId(toplevel: HyprlandToplevel): string {
        if (!toplevel) return "";
        return (toplevel.wayland?.appId || toplevel.initialClass || toplevel.class) ?? ""
    }

    function getToplevelEntry(toplevel: HyprlandToplevel): DesktopEntry {
        if (!toplevel) return null;
        return heuristicLookup(getToplevelAppId(toplevel));
    }

    function getToplevelIcon(toplevel: HyprlandToplevel): string {
        if (!toplevel) return "";
        return getAppIcon(getToplevelAppId(toplevel));
    }
}
