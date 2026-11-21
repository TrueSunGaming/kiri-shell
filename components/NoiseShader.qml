import QtQuick
import QtQuick.Effects

ShaderEffect {
    anchors.fill: parent

    property var mask: parent
    property color tintColor: Qt.rgba(1.0, 1.0, 1.0, 0.12)
    property real noiseIntensity: 0.5
    readonly property vector2d resolution: Qt.vector2d(width, height)

    fragmentShader: "../shaders/noise.frag.qsb"
}
