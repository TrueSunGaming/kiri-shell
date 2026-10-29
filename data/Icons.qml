pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    FileView {
        id: jsonFile
        path: Qt.resolvedUrl("./icons.json")
        blockLoading: true
    }

    readonly property var jsonData: JSON.parse(jsonFile.text())

    function getIcon(name): string {
        return jsonData[name] ?? "";
    }
}
