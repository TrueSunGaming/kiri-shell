import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.data
import qs.util

Item {
    id: root

    property real cellWidth: Sizing.widgetGridSize
    property real cellHeight: cellWidth
    property real columnSpacing: Sizing.sizeM
    property real rowSpacing: Sizing.sizeM
    property list<GridItem> items: []

    // max{n∈Z : wn+s(n-1)<=x} = floor((x+s)/(w+s))
    readonly property int columns: Math.max(1, Math.floor((width + columnSpacing) / (cellWidth + columnSpacing)))
    readonly property int rows: Math.max(1, Math.floor((height + columnSpacing) / (cellHeight + columnSpacing)))
    readonly property real gridWidth: cellWidth * columns + columnSpacing * (columns - 1)
    readonly property real gridHeight: cellHeight * rows + rowSpacing * (rows - 1)

    onColumnsChanged: console.log(columns)

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

                x: modelData.getX(root.cellWidth, root.columnSpacing)
                y: modelData.getY(root.cellHeight, root.rowSpacing)
                width: root.cellWidth * modelData.columnSpan + root.columnSpacing * Math.max(0, modelData.columnSpan - 1)
                height: root.cellHeight * modelData.rowSpan + root.rowSpacing * Math.max(0, modelData.rowSpan - 1)

                children: [modelData.item]

                Binding {
                    target: modelData.item
                    property: "anchors.fill"
                    value: gridItem
                }
            }
        }
    }
}
