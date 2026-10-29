import QtQuick

Matrix4x4 {
    required property real rectWidth
    required property real rectHeight
    property point origin: Qt.point(rectWidth / 2, rectHeight / 2)
    property real topScale: 1
    property real bottomScale: 1
    property real leftScale: 1
    property real rightScale: 1

    readonly property matrix4x4 originMatrix: Qt.matrix4x4(
        1, 0, 0, origin.x,
        0, 1, 0, origin.y,
        0, 0, 1, 0,
        0, 0, 0, 1
    )

    readonly property real m11: 2 * topScale * bottomScale / (topScale + bottomScale) // base x scale
    readonly property real m22: 2 * leftScale * rightScale / (leftScale + rightScale) // base y scale
    readonly property real m41: 2 / rectWidth * (rightScale - leftScale) / (rightScale + leftScale) // x perspective
    readonly property real m42: 2 / rectHeight * (topScale - bottomScale) / (topScale + bottomScale) // y perspective

    readonly property matrix4x4 scaleMatrix: Qt.matrix4x4(
        m11, 0, 0, 0,
        0, m22, 0, 0,
        0, 0, 1, 0,
        m41, m42, 0, 1
    )

    matrix: originMatrix.times(scaleMatrix).times(originMatrix.inverted())
}
