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
    readonly property bool hovered: content.hovered
    property Item popupContent

    property bool open: false
    property bool grabFocus: open

    visible: content.animProgress > 0
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

    GlassContainer {
        id: content

        anchors.top: parent.top
        anchors.topMargin: Sizing.sizeXXS
        anchors.horizontalCenter: parent.horizontalCenter

        content: root.popupContent
        padding: root.padding
        open: root.open
    }
}
