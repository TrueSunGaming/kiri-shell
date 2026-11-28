import QtQuick
import qs.components
import qs.data
import qs.services

Item {
    id: root

    property real spacing: Sizing.sizeM
    property bool showDate: true
    property bool showSeconds: false

    readonly property real fontSize: Math.floor((width / clockTest.trueWidth) * clockTest.font.pixelSize)
    readonly property real totalHeight: clock.trueHeight + spacing + day.trueHeight
    readonly property bool actuallyShowDate: showDate && totalHeight <= height

    StyleText {
        id: clockTest
        visible: false

        text: root.showSeconds ? "00:00:00 AM" : "00:00 AM"
        weightOverride: clock.weightOverride
    }

    Item {
        anchors.centerIn: parent
        implicitWidth: clock.trueWidth
        implicitHeight: root.actuallyShowDate ? root.totalHeight : clock.trueHeight

        DebugBorder {
            border.color: "orange"
        }

        GlassText {
            id: clock

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: verticalCorrection

            metrics.text: root.showSeconds ? "00:00:00 AM" : "00:00 AM"
            text: root.showSeconds ? Clock.long12hr : Clock.short12hr
            // text: metrics.text
            weightOverride: Font.Black
            font.pixelSize: root.fontSize
            color: Colors.accentShield
        }

        GlassText {
            id: day

            anchors.top: clock.bottom
            anchors.topMargin: verticalCorrection + clock.verticalCorrection + root.spacing
            anchors.horizontalCenter: clock.horizontalCenter

            visible: root.actuallyShowDate

            metrics.text: "Wednesday, September 30"
            text: Clock.longDate
            weightOverride: Font.ExtraBold
            font.pixelSize: Sizing.relative(root.fontSize, -2.5) // never longer than time
            color: Colors.accentShield
        }
    }
}
