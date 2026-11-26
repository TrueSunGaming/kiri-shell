import QtQuick
import qs.services

Rectangle {
    id: root

    anchors.fill: parent
    opacity: 0.5
    color: "transparent"
    border.color: "red"
    border.width: 2
    z: 100
    visible: Config.data.debug.showBorders

    Rectangle {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        implicitWidth: 1
        color: root.border.color
        opacity: 0.5
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        implicitHeight: 1
        color: root.border.color
        opacity: 0.5
    }
}
