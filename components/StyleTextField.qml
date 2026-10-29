import QtQuick.Controls
import qs.data

TextField {
    property bool error: false
    property StyleText fontData: StyleText {}

    font.family: fontData.font.family
    font.features: fontData.font.features
    font.variableAxes: fontData.font.variableAxes
    color: error ? Colors.error : fontData.color
}
