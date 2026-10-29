import QtQuick
import QtQuick.Controls
import qs.data

Slider {
    id: root

    property real animVisualPosition: visualPosition

    background: Rectangle {
        color: Qt.alpha("white", 0.24)
        y: root.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 4
        width: root.availableWidth
        height: implicitHeight
        radius: height / 2

        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: root.animVisualPosition * parent.width
            radius: parent.radius
            // color: Colors.accent

            gradient: Gradient {
                orientation: Gradient.Horizontal

                GradientStop {
                    position: 0
                    color: Qt.lighter(Colors.accent, 0.8)
                }

                GradientStop {
                    position: 1
                    color: Qt.lighter(Colors.accent, 1.2)
                }
            }
        }
    }

    handle: Rectangle {
        x: root.animVisualPosition * (root.availableWidth - width)
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: Sizing.fontSize
        implicitHeight: implicitWidth
        radius: width / 2
        color: Qt.lighter(Colors.accent, 1.2)
    }
}
