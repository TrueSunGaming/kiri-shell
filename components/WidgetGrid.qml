import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.data
import qs.services
import qs.util

Item {
    id: root

    property real cellPreferredWidth: Sizing.widgetGridSize
    property real cellPreferredHeight: cellPreferredWidth
    property real columnSpacing: Sizing.sizeM
    property real rowSpacing: Sizing.sizeM
    property list<GridItem> items: []

    function cellCount(space: real, size: real, spacing: real): int {
        // max{n∈Z : wn+s(n-1)<=x} = floor((x+s)/(w+s))
        return Math.max(1, Math.floor((space + spacing) / (size + spacing)));
    }

    function correctSize(original: real, space: real, spacing: real): real {
        // if (Config.data.desktop.forceCenterWidgets != "grid") return original;
        const count = cellCount(space, original, spacing);
        return (space - spacing * (count - 1)) / count;
    }

    readonly property real cellWidth: correctSize(cellPreferredWidth, width, columnSpacing)
    readonly property real cellHeight: correctSize(cellPreferredHeight, height, rowSpacing)

    readonly property int columns: cellCount(width, cellWidth, columnSpacing)
    readonly property int rows: cellCount(height, cellHeight, rowSpacing)
    readonly property real gridWidth: cellWidth * columns + columnSpacing * (columns - 1)
    readonly property real gridHeight: cellHeight * rows + rowSpacing * (rows - 1)

    Item {
        id: gridContainer

        anchors.centerIn: parent
        width: root.gridWidth
        height: root.gridHeight
        clip: true

        Repeater {
            model: ScriptModel {
                values: [...root.items]
                objectProp: "item"
                comparisonMode: ObjectComparison.Identity
            }

            delegate: Item {
                id: gridItem

                required property GridItem modelData

                readonly property point pos: modelData.getScreenPos(root)
                x: pos.x
                y: pos.y

                readonly property point size: modelData.getScreenSize(root)
                width: size.x
                height: size.y

                Binding {
                    target: modelData.item
                    property: "parent"
                    value: gridItem
                }

                Binding {
                    target: modelData.item
                    when: modelData.item.parent == gridItem
                    property: "anchors.fill"
                    value: gridItem
                }

                DebugBorder {}
            }
        }

        DebugBorder {
            border.color: "cyan"
        }
    }

    DebugBorder {
        border.color: "cyan"
    }
}
