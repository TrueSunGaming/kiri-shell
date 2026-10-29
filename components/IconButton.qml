import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.data

WrapperRectangle {
    id: root

    signal tapped

    property bool enabled: true
    property string iconName
    property real iconSize: Sizing.relative(Sizing.fontSize, 2)

    property real bgOpacity: tapHandler.pressed ? 0.18 : hoverHandler.hovered ? 0.12 : 0

    Behavior on bgOpacity {
        Spring {
            damping: 1
        }
    }

    margin: Sizing.relative(iconSize, -4)
    radius: Sizing.relative(margin, 2)
    color: Qt.alpha(Colors.accent, bgOpacity)

    MaterialIcon {
        id: icon
        iconName: root.iconName
        implicitSize: root.iconSize
        text.color: root.enabled ? Colors.text : Colors.disabledText
    }

    HoverHandler {
        id: hoverHandler
        enabled: root.enabled
    }

    TapHandler {
        id: tapHandler
        enabled: root.enabled
        onTapped: root.tapped()
    }
}
