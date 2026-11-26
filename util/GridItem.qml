import QtQuick

QtObject {
    required property int row
    required property int column
    property int rowSpan: 1
    property int columnSpan: 1
    property Item item

    function getPos(coord: int, cellSize: real, spacing: real): real {
        return coord * (cellSize + spacing);
    }

    function getX(cellWidth: real, columnSpacing: real): real {
        return getPos(column, cellWidth, columnSpacing);
    }

    function getY(cellHeight: real, rowSpacing: real): real {
        return getPos(row, cellHeight, rowSpacing);
    }
}
