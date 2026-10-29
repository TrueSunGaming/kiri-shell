import QtQuick
import qs.data
import qs.services

Item {
    property string iconName
    property real implicitSize: Sizing.sizeL
    property alias text: textItem

    implicitWidth: implicitSize
    implicitHeight: implicitSize

    StyleText {
        id: textItem

        anchors.fill: parent

        text: Icons.getIcon(parent.iconName) || parent.iconName

        font {
            family: Fonts.materialSymbols.name
            pixelSize: height
            variableAxes: {
                "wght": 400
            }
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
