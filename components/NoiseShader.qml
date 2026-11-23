import QtQuick
import QtQuick.Effects

ShaderEffect {
    id: root

    anchors.fill: parent

    property Item maskItem

    readonly property ShaderEffectSource mask: ShaderEffectSource {
        sourceItem: root.maskItem
        hideSource: true
    }

    property color tintColor: Qt.rgba(1.0, 1.0, 1.0, 0.12)
    property real noiseIntensity: 0.35
    readonly property vector2d resolution: Qt.vector2d(Math.max(width, 1), Math.max(height, 1))

    visible: width > 0 && height > 0 && maskItem != null

    fragmentShader: "../shaders/noise.frag.qsb"
}
