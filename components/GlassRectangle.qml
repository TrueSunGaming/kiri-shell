import QtQuick
import qs.data

Rectangle {
    id: root

    color: Colors.shield
    border.color: Colors.createGlassBorder(color)
    border.width: 1

    Rectangle {
        id: maskRect
        anchors.fill: parent
        radius: root.radius
        color: root.color
        border.width: root.border.width
        border.color: root.border.color
    }

    NoiseShader {
        maskItem: maskRect
    }
}
