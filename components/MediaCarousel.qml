import QtQuick
import Quickshell.Services.Mpris
import qs.components
import qs.data
import qs.services

Carousel {
    implicitWidth: dummyPlayer.implicitWidth
    implicitHeight: dummyPlayer.implicitHeight

    MediaPlayer {
        id: dummyPlayer
        visible: false
        player: null
    }

    fallbackText: "No active player"
    model: Media.playerModel

    // clipped by 1 pixel on some screens due to qt rounding error
    delegate: MediaPlayer {
        required property MprisPlayer modelData
        player: modelData
        visible: true
    }
}
