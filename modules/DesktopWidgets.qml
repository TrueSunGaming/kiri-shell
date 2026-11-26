import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Mpris
import Quickshell.Wayland
import Quickshell.Widgets
import qs.components
import qs.data
import qs.modules.widgets
import qs.services
import qs.util

PanelWindow {
    id: root

    required property ShellScreen currentScreen
    screen: currentScreen

    readonly property Component loaderGridItemComponent: Qt.createComponent("../util/LoaderGridItem.qml")

    property bool desktopShown: Hypr.getMonitor(screen)?.floatingOnly ?? true
    property real animProgress: desktopShown ? 1 : 0

    Behavior on animProgress {
        Spring {}
    }

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    WlrLayershell.layer: WlrLayer.Background

    color: "transparent"
    surfaceFormat.opaque: false

    Item {
        anchors.fill: parent
        anchors.margins: Sizing.sizeM
        visible: root.animProgress > 0
        opacity: root.animProgress

        WidgetGrid {
            id: grid
            anchors.fill: parent

            items: WidgetConfig.widgets.map((v) => loaderGridItemComponent.createObject(null, {
                        widgetID: v.widgetID,
                        anchor: v.anchor,
                        row: v.row,
                        column: v.column,
                        rowSpan: v.rowSpan,
                        columnSpan: v.columnSpan,
                        options: v.options
            }))
        }

        TapHandler {
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onTapped: console.log("hi")
        }
    }
}
