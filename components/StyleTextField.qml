import QtQuick.Controls
import qs.data

TextField {
    property bool error: false
    property StyleText fontData: StyleText {}

    font.family: fontData.font.family
    font.features: fontData.font.features
    font.variableAxes: fontData.font.variableAxes
    font.pixelSize: fontData.font.pixelSize
    // style: fontData.style
    // styleColor: fontData.styleColor
    color: error ? Colors.error : fontData.color

    background: null
    padding: 0
}
