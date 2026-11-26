import QtQuick
import qs.components
import qs.services

QtObject {
    property string anchor: "top-left"
    required property int row
    required property int column
    property int rowSpan: 1
    property int columnSpan: 1
    property Item item

    readonly property string rowAnchor: anchor.split("-")[0]
    readonly property string columnAnchor: anchor.split("-")[1]

    readonly property string centerMode: Config.data.desktop.forceCenterWidgets ?? "off"

    function forceCenter(size: int, count: int): int {
        if (centerMode == "off" || (count - size) % 2 == 0) return size;
        if (centerMode == "add") return size + 1;
        if (centerMode == "subtract") return size - 1;
        return size;
    }

    function getAnchorRow(rows: int): int {
        if (rowAnchor == "top") return 0;
        if (rowAnchor == "bottom") return rows - rowSpan;
        if (rowAnchor == "center") return Math.floor(rows / 2 - getGridHeight(rows) / 2);
        console.warn(`Invalid row anchor: ${rowAnchor}`);
        return 0;
    }

    function getAnchorColumn(columns: int): int {
        if (columnAnchor == "left") return 0;
        if (columnAnchor == "right") return columns - columnSpan;
        if (columnAnchor == "center") return Math.floor(columns / 2 - getGridWidth(columns) / 2);
        console.warn(`Invalid column anchor: ${columnAnchor}`);
        return 0;
    }

    function getPos(grid: WidgetGrid): point {
        return Qt.point(column + getAnchorColumn(grid.columns), row + getAnchorRow(grid.rows));
    }

    function getGridWidth(columns: int): int {
        if (columnAnchor != "center") return columnSpan;
        return forceCenter(columnSpan, columns);
    }

    function getGridHeight(rows: int): int {
        if (rowAnchor != "center") return rowSpan;
        return forceCenter(rowSpan, rows);
    }

    function getScreenSize(grid: WidgetGrid, coord: int): point {
        const gridWidth = getGridWidth(grid.columns);
        const gridHeight = getGridHeight(grid.rows);
        return Qt.point(
            grid.cellWidth * gridWidth + grid.columnSpacing * Math.max(0, gridWidth - 1),
            grid.cellHeight * gridHeight + grid.rowSpacing * Math.max(0, gridHeight - 1)
        );
    }

    function getScreenCoord(coord: int, cellSize: real, spacing: real): real {
        return coord * (cellSize + spacing);
    }

    function getScreenPos(grid: WidgetGrid): point {
        const pos = getPos(grid);
        return Qt.point(
            getScreenCoord(pos.x, grid.cellWidth, grid.columnSpacing),
            getScreenCoord(pos.y, grid.cellHeight, grid.rowSpacing)
        )
    }
}
