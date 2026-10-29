import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import Quickshell.Widgets
import qs.components
import qs.data
import qs.services

GlassRectangle {
    id: root

    radius: Sizing.sizeM
    implicitWidth: mediaWrapper.implicitWidth
    implicitHeight: mediaWrapper.implicitHeight

    WrapperItem {
        id: mediaWrapper
        margin: Sizing.sizeM

        MediaCarousel {}
    }
}
