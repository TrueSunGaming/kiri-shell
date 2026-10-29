import QtQuick
import Quickshell.Widgets
import qs.data

WrapperRectangle {
    id: root

    signal tapped

    property bool selectable: false
    property bool selected: false

    margin: Sizing.sizeM
    radius: margin

    color: "transparent"
    gradient: Gradient {
        id: gradient

        orientation: Gradient.Vertical

        property real saturation: root.selected ? Colors.accentSaturation : 0
        property real lightness: root.selected ? Colors.accentLightness: 1
        property real opacityMultiplier: 1 + (root.selected ? 2 : 0) + (hoverHandler.hovered ? 1 : 0)

        Behavior on opacityMultiplier {
            Spring {
                damping: 1
            }
        }

        Behavior on saturation {
            Spring {
                damping: 1
            }
        }

        Behavior on lightness {
            Spring {
                damping: 1
            }
        }

        GradientStop {
            position: 0
            color: Qt.hsla(
                Colors.accentHue,
                gradient.saturation,
                gradient.lightness,
                0.06 * gradient.opacityMultiplier
            )
        }

        GradientStop {
            position: 1
            color: Qt.hsla(
                Colors.accentHue,
                gradient.saturation,
                gradient.lightness,
                0.04 * gradient.opacityMultiplier
            )
        }
    }

    HoverHandler {
        id: hoverHandler
        enabled: root.selectable
    }

    TapHandler {
        onTapped: root.tapped()
        enabled: root.selectable
    }
}
