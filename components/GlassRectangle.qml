import QtQuick
import qs.data

Rectangle {
    id: rect

    color: Colors.shield
    border.color: Colors.glassBorder
    border.width: 1
    layer.enabled: true

    NoiseShader {}
}
