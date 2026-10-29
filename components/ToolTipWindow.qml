import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.data

PopupWindow {
    id: root

    required property Item anchorItem

    property string text
    property bool open: false
    property real animProgress: open ? 1 : 0

    Behavior on animProgress {
        Spring {}
    }

    visible: animProgress > 0

    anchor.item: anchorItem
    anchor.rect.x: anchorItem.width / 2 - width / 2
    anchor.rect.y: anchorItem.height + Sizing.sizeMicro
    implicitWidth: Math.max(content.implicitWidth + 1, 1)
    implicitHeight: Math.max(content.implicitHeight + 1, 1)

    mask: Region {}

    color: "transparent"
    surfaceFormat.opaque: false

    GlassRectangle {
        id: content

        radius: Sizing.sizeXXS
        implicitWidth: textWrapper.implicitWidth
        implicitHeight: textWrapper.implicitHeight

        opacity: root.animProgress

        WrapperItem {
            id: textWrapper

            margin: content.radius

            StyleText {
                text: root.text
                color: Colors.secondaryText
            }
        }
    }
}
