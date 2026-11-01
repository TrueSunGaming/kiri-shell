import QtQuick
import Quickshell.Widgets
import qs.data

GlassRectangle {
    id: root

    property Item content
    property real padding: Sizing.sizeM
    property bool open: true
    property real animProgress: open ? 1 : 0
    readonly property bool hovered: hover.hovered

    Behavior on animProgress {
        Spring {}
    }

    radius: padding
    implicitWidth: content != null ? contentWrapper.implicitWidth : 200
    implicitHeight: content != null ? contentWrapper.implicitHeight : 200

    opacity: animProgress

    WrapperItem {
        id: contentWrapper

        anchors.fill: parent
        margin: root.padding
        child: root.content
    }

    transform: MorphAnimation {
        item: root
        animProgress: root.animProgress
    }

    HoverHandler {
        id: hover
    }
}
