pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.services
import qs.util

Singleton {
    id: root

    FileView {
        id: jsonFile
        path: Qt.resolvedUrl("./scripts.json")
        blockLoading: true
    }

    readonly property var jsonData: JSON.parse(jsonFile.text())

    Instantiator {
        id: scriptInstantiator

        model: ScriptModel {
            values: [...Object.keys(root.jsonData), ...Object.keys(Config.data.launcher.customScripts)]
        }

        delegate: ScriptData {
            required property string modelData
            scriptID: modelData
        }
    }

    readonly property ScriptModel scripts: ScriptModel {
        values: {
            const result = [];
            for (let i = 0; i < scriptInstantiator.count; i++) result.push(scriptInstantiator.objectAt(i));
            return result;
        }
    }

    function getScript(scriptID: string): var {
        return jsonData[scriptID] ?? Config.data.launcher.customScripts[scriptID] ?? null;
    }
}
