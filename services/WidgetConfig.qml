pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.util

Singleton {
    id: root

    readonly property Component gridItemComponent: Qt.createComponent("../util/JsonGridItem.qml")

    property list<JsonGridItem> widgets: []

    Connections {
        target: Config.data.desktop

        function onWidgetsChanged() {
            const parsed = [];
            for (const i of Config.data.desktop.widgets) {
                parsed.push(gridItemComponent.createObject(null, i))
            }
            root.widgets = parsed;
        }
    }
}
