pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property FontLoader defaultFont: FontLoader {
        source: "../assets/SUSE.ttf"
    }

    readonly property FontLoader materialSymbols: FontLoader {
        source: "../assets/MaterialSymbols.ttf"
    }
}
