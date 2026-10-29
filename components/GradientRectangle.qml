import QtQuick
import QtQuick.Shapes
import qs.data

Rectangle {
    id: root

    color: Colors.shield

    property color startColor: Colors.popupGradStart
    property color endColor: Colors.popupGradEnd
    property ShapeGradient shapeGradient: LinearGradient {
        x1: 0
        y1: 0
        x2: root.width
        y2: root.height

        GradientStop {
            position: 0
            color: root.startColor
        }

        GradientStop {
            position: 1
            color: root.endColor
        }
    }

    Shape {
        anchors.fill: parent

        ShapePath {
            strokeWidth: 0

            PathRectangle {
                width: root.width
                height: root.height
                radius: root.radius
            }

            fillGradient: root.shapeGradient
        }
    }
}
