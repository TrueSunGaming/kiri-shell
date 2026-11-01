import QtQuick

FlexScaleMatrix {
    required property Item item
    property real animProgress: 1

    rectWidth: item.width
    rectHeight: item.height
    origin.x: item.width / 2
    origin.y: 0
    topScale: 0.5 + animProgress / 2
    bottomScale: animProgress
}
