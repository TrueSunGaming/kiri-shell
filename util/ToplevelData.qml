import Quickshell
import Quickshell.Hyprland
import qs.services

Scope {
    required property HyprlandToplevel toplevel

    readonly property DesktopEntry desktopEntry: Apps.getToplevelEntry(toplevel)
    readonly property string name: desktopEntry?.name ?? toplevel?.title ?? ""
    readonly property string icon: Apps.getToplevelIcon(toplevel)

    readonly property bool isolated: (toplevel?.workspace?.toplevels.values.length ?? 0) <= 1
    readonly property bool active: toplevel?.workspace?.active ?? false
    readonly property bool floating: toplevel?.lastIpcObject.floating ?? false

    readonly property string dispatchQuery: `window = "address:0x${toplevel?.address ?? "0"}"`;

    function activate(): void {
        toplevel?.wayland?.activate();
    }

    function close(): void {
        toplevel?.wayland?.close();
    }

    function toggleFloating(): void {
        Hyprland.dispatch(`hl.dsp.window.float({ action = "toggle", ${dispatchQuery} })`);
    }

    function moveToWorkspace(workspace: int): void {
        Hyprland.dispatch(`hl.dsp.window.move({ workspace = ${workspace}, ${dispatchQuery} })`);
    }

    function moveToNewWorkspace(): void {
        moveToWorkspace(Hypr.newWorkspace);
    }
}
