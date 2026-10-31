import Quickshell
import Quickshell.Hyprland

Scope {
    id: root

    required property ShellScreen screen

    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(screen)
    readonly property HyprlandWorkspace activeWorkspace: monitor?.activeWorkspace ?? null

    readonly property list<HyprlandToplevel> toplevels: activeWorkspace?.toplevels.values ?? []
    readonly property bool desktopOnly: toplevels.length == 0
    readonly property bool floatingOnly: desktopOnly || toplevels.every((t) => t.lastIpcObject.floating ?? false)

    readonly property HyprlandToplevel focusedToplevel: {
        if (!activeWorkspace) return null;
        if (Hyprland.activeToplevel && Hyprland.activeToplevel.workspace == activeWorkspace) return Hyprland.activeToplevel;
        return null;
    }

    property HyprlandToplevel lastFocusedToplevel: null
    onFocusedToplevelChanged: {
        if (focusedToplevel != null) lastFocusedToplevel = focusedToplevel;
    }

    readonly property HyprlandToplevel activeToplevelFallback: {
        if (!activeWorkspace) return null;
        if (lastFocusedToplevel && lastFocusedToplevel.workspace == activeWorkspace) return lastFocusedToplevel;
        return activeWorkspace.toplevels.values[0] ?? null;
    }

    readonly property ToplevelData activeToplevel: ToplevelData {
        toplevel: root.focusedToplevel ?? root.activeToplevelFallback
    }
}
