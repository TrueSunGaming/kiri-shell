import QtQuick.Layouts
import Quickshell.Widgets
import qs.data

AccentPill {
    id: root

    property string appName
    property url appIcon
    property alias text: textItem

    RowLayout {
        spacing: Sizing.sizeMicro

        IconImage {
            source: root.appIcon
            visible: source != ""
            Layout.fillHeight: true
            Layout.preferredWidth: height
        }

        StyleText {
            Layout.fillWidth: true
            id: textItem
            text: root.appName
        }
    }
}
