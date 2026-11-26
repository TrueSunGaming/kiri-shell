import QtQuick
import Quickshell.Io
import qs.components
import qs.data

JsonObject {
    id: root

    property string widgetID
    property string anchor: "top-left"
    property int row: 0
    property int column: 0
    property int rowSpan: Widgets.getData(widgetID)?.defaultHeight ?? 1
    property int columnSpan: Widgets.getData(widgetID)?.defaultWidth ?? 1
    property var options: ({})
}
