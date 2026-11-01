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
    required property Item contentContainer

    property bool open: false
    property bool grabFocus: open

    visible: open
    anchor.item: menuBarItem
    anchor.rect.x: menuBarItem.width / 2 - width / 2
    anchor.rect.y: Sizing.barSize - menuBarItem.y
    implicitWidth: Math.max(contentContainer.implicitWidth + 2, 1)
    implicitHeight: contentContainer.implicitHeight + contentContainer.anchors.topMargin + 2

    color: "transparent"
    surfaceFormat.opaque: false

    HyprlandFocusGrab {
        windows: [menuBar, root]
        active: root.grabFocus
        onCleared: root.menuBarItem.deselect()
    }
}
