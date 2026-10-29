//@ pragma UseQApplication

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import qs.modules
import qs.components

ShellRoot {
    id: root

    property list<Scope> screens
    readonly property Scope focusedScreen: screens.find(screen => Hyprland.focusedMonitor == Hyprland.monitorFor(screen.modelData)) ?? null

    Variants {
        model: Quickshell.screens

        delegate: Scope {
            id: screenScope

            required property ShellScreen modelData

            property Launcher launcher: i_launcher

            MenuBar {
                currentScreen: screenScope.modelData
            }

            Launcher {
                id: i_launcher
                currentScreen: screenScope.modelData
            }

            DesktopWidgets {
                currentScreen: screenScope.modelData
            }

            Component.onCompleted: root.screens.push(this)
            Component.onDestruction: {
                const idx = root.screens.indexOf(this);
                if (idx >= 0)
                root.screens.splice(idx, 1);
            }
        }
    }

    IpcHandler {
        target: "launcher"

        function open(): void {
            root.focusedScreen.launcher.open = true;
        }

        function close(): void {
            root.focusedScreen.launcher.open = false;
        }

        function toggle(): void {
            root.focusedScreen.launcher.open = !root.focusedScreen.launcher.open;
        }
    }
}
