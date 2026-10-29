import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import qs.data
import qs.modules

PopupWindow {
    id: root

    required property MenuBar menuBar
    required property Item menuBarItem

    property real padding: Sizing.sizeM
    property alias container: content
    property alias hoverHandler: hover
    property Item popupContent

    property bool open: false
    property bool grabFocus: open
    property real animProgress: open ? 1 : 0

    Behavior on animProgress {
        Spring {}
    }

    visible: animProgress > 0
    anchor.item: menuBarItem
    anchor.rect.x: menuBarItem.width / 2 - width / 2
    anchor.rect.y: Sizing.barSize - menuBarItem.y
    implicitWidth: Math.max(content.implicitWidth + 2, 1)
    implicitHeight: content.implicitHeight + content.anchors.topMargin + 2

    color: "transparent"
    surfaceFormat.opaque: false

    HyprlandFocusGrab {
        windows: [menuBar, root]
        active: root.grabFocus
        onCleared: root.menuBarItem.deselect()
    }

    GlassRectangle {
        id: content

        anchors.top: parent.top
        anchors.topMargin: Sizing.sizeXXS
        anchors.horizontalCenter: parent.horizontalCenter

        radius: root.padding
        implicitWidth: root.popupContent != null ? contentWrapper.implicitWidth : 200
        implicitHeight: root.popupContent != null ? contentWrapper.implicitHeight : 200

        opacity: root.animProgress

        WrapperItem {
            id: contentWrapper

            anchors.fill: parent
            margin: root.padding
            child: root.popupContent
        }

        transform: FlexScaleMatrix {
            id: contentMatrix

            rectWidth: content.width
            rectHeight: content.height
            origin.x: content.width / 2
            origin.y: 0
            topScale: 0.5 + root.animProgress / 2
            bottomScale: root.animProgress
        }

        HoverHandler {
            id: hover
        }
    }
}
