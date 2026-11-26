pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    FileView {
        id: jsonFile
        path: Qt.resolvedUrl("./widgets.json")
        blockLoading: true
    }

    readonly property var jsonData: JSON.parse(jsonFile.text())

    function getData(name: string): var {
        return jsonData[name] ?? "";
    }

    function getComponentPath(name: string): string {
        const data = getData(name);
        if (!data) return "";
        return Qt.resolvedUrl(`../modules/widgets/${data.component}.qml`)
    }
}
