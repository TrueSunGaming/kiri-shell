import QtQuick
import Quickshell.Widgets
import qs.data

WrapperRectangle {
    id: root

    property bool tappable: false

    readonly property bool hovered: hover.hovered
    readonly property bool pressed: tap.pressed
    signal tapped

    radius: Sizing.sizeM
    leftMargin: Sizing.relative(radius, -1.5)
    rightMargin: leftMargin
    topMargin: Sizing.relative(leftMargin, -1.5)
    bottomMargin: topMargin

    property real bgOpacity: 0.24 + (pressed ? 0.24 : (hovered ? 0.18 : 0))

    Behavior on bgOpacity {
        Spring {
            damping: 1
        }
    }

    color: Qt.alpha(Colors.accent, bgOpacity)

    HoverHandler {
        id: hover
        enabled: root.tappable
    }

    TapHandler {
        id: tap
        enabled: root.tappable
        onTapped: root.tapped()
    }
}
