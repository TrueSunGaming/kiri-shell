import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import qs.data
import qs.modules

MenuBarPopup {
    id: root

    property real padding: Sizing.sizeM
    readonly property bool hovered: content.hovered
    property Item popupContent

    visible: content.animProgress > 0

    GlassContainer {
        id: content

        anchors.top: parent.top
        anchors.topMargin: Sizing.sizeXXS
        anchors.horizontalCenter: parent.horizontalCenter

        content: root.popupContent
        padding: root.padding
        open: root.open
    }

    contentContainer: content
}
