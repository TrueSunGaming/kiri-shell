import QtQuick
import qs.data

GridItem {
    id: root
    property string widgetID

    item: Loader {
        source: Widgets.getComponentPath(root.widgetID)
    }
}
