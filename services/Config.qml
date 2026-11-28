pragma Singleton

import QtCore
import QtQuick
import Quickshell
import Quickshell.Io
import qs.util

Singleton {
    id: root

    readonly property string configFolderName: "kiri-shell"
    readonly property string configParentFolder: Quickshell.env("XDG_CONFIG_HOME") || StandardPaths.writableLocation(StandardPaths.ConfigLocation)
    readonly property string configDir: `${configParentFolder}/${configFolderName}`

    readonly property Component jsonGridItemComponent: Qt.createComponent("../util/JsonGridItem.qml")

    property alias file: configFile
    property alias data: configData

    function openFolder(): void {
        Qt.openUrlExternally(configDir);
    }

    FileView {
        id: configFile
        path: root.configDir + "/config.json"
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()

        onLoadFailed: (err) => {
            if (err == FileViewError.FileNotFound) {
                writeAdapter();
                return;
            }
            console.error("Failed to load config: " + err.toString());
        }

        JsonAdapter {
            id: configData

            property JsonObject style: JsonObject {
                property JsonObject colors: JsonObject {
                    property real accentHue: 178
                    property real accentSaturation: 0.54
                    property real accentLightness: 0.48
                }
            }

            property JsonObject desktop: JsonObject {
                property string forceCenterWidgets: "off"
                property var widgets: []
            }

            property JsonObject debug: JsonObject {
                property bool showBorders: false
            }

            property JsonObject launcher: JsonObject {
                property var customScripts: ({})
            }
        }
    }
}
