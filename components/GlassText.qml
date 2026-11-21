import QtQuick
import QtQuick.Shapes
import qs.data

StyleText {
    id: root

    color: Colors.shield
    style: Text.Normal
    layer.enabled: true

    Text {
        text: root.text ?? ""
        font: root.font
        color: "transparent"
        style: Text.Outline
        styleColor: Colors.glassBorder
    }

    Text {
        id: maskText
        anchors.fill: parent
        text: root.text ?? ""
        font: root.font
        color: root.color
        style: root.style
        styleColor: root.styleColor
    }

    NoiseShader {
        maskItem: maskText
    }
}
