import QtQuick
import qs.components
import qs.data
import qs.services

Item {
    id: root

    property real spacing: Sizing.sizeM
    property bool showDate: true
    property bool showSeconds: false

    implicitWidth: Math.max(clock.trueWidth, showDate ? day.trueWidth : 0, 1)
    implicitHeight: clock.trueHeight + (showDate ? day.trueHeight + spacing : 0)

    GlassText {
        id: clock

        anchors.top: parent.top
        anchors.topMargin: verticalCorrection
        anchors.left: parent.left
        anchors.leftMargin: horizontalCorrection

        metrics.text: root.showSeconds ? "00:00:00 AM" : "00:00 AM"
        text: root.showSeconds ? Clock.long12hr : Clock.short12hr
        weightOverride: Font.Black
        font.pixelSize: Sizing.relative(Sizing.fontSize, 5.5)
    }

    GlassText {
        id: day

        anchors.top: clock.bottom
        anchors.topMargin: verticalCorrection + clock.verticalCorrection + root.spacing
        anchors.horizontalCenter: clock.horizontalCenter

        visible: root.showDate

        text: Clock.longDate
        weightOverride: Font.ExtraBold
        font.pixelSize: Sizing.relative(Sizing.fontSize, 3)
    }
}
