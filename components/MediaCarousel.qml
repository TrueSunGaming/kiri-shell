import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import qs.components
import qs.data
import qs.services

Carousel {
    id: root

    property bool fixedSize: false

    implicitWidth: dummyPlayer.implicitWidth
    implicitHeight: dummyPlayer.implicitHeight

    MediaPlayer {
        id: dummyPlayer
        visible: false
        player: null
        fixedSize: true
    }

    fallbackText: "No active player"
    model: Media.playerModel

    // clipped by 1 pixel on some screens due to qt rounding error
    delegate: MediaPlayer {
        required property MprisPlayer modelData
        player: modelData
        visible: true
        Layout.preferredWidth: root.width
        Layout.maximumWidth: root.width
        Layout.preferredHeight: root.height
        Layout.maximumHeight: root.height
        fixedSize: root.fixedSize
        // Layout.fillHeight: true
    }
}
