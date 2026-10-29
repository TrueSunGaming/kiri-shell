import QtQuick
import QtQuick.Effects
import qs.data
import qs.services

Text {
    id: root

    property int weightOverride: 0
    property bool bold: false
    property bool italic: false
    property alias metrics: textMetrics

    readonly property real trueWidth: metrics.tightBoundingRect.width
    readonly property real trueHeight: metrics.tightBoundingRect.height
    readonly property real horizontalCorrection: (trueWidth - implicitWidth) / 2
    readonly property real verticalCorrection: (trueHeight - implicitHeight) / 2

    TextMetrics {
        id: textMetrics
        text: root.text
        font: root.font
    }

    color: Colors.text
    style: Text.Raised
    styleColor: Qt.alpha(Qt.darker(color, 5), 0.7)

    font {
        family: Fonts.defaultFont.font.family
        pixelSize: Sizing.fontSize
        italic: italic

        features: {
            "tnum": 1,
            "lnum": 1
        }

        variableAxes: {
            "wght": weightOverride ? weightOverride : (bold ? Font.Bold : Font.Normal)
        }
    }
}
