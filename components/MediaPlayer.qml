import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.data
import qs.util

ColumnLayout {
    id: root

    required property MprisPlayer player
    property bool fixedSize: false
    readonly property real dataWidth: Sizing.relative(Sizing.mediaImageSize, 1)

    spacing: Sizing.sizeMicro

    PlayerData {
        id: playerData
        player: root.player
    }

    AppPill {
        appName: playerData.appName
        appIcon: playerData.appIcon
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: Sizing.sizeXS

        Item {
            // Layout.minimumHeight: Sizing.mediaImageSize
            Layout.fillHeight: true
            Layout.preferredWidth: height

            Binding on Layout.preferredHeight {
                when: root.fixedSize
                value: Sizing.mediaImageSize
            }

            Image {
                id: trackArt

                anchors.fill: parent
                source: playerData.trackArtUrl
                fillMode: Image.PreserveAspectCrop
                mipmap: true
                smooth: false
                visible: false
            }

            Rectangle {
                id: trackArtMask

                anchors.fill: parent
                layer.enabled: true

                radius: Sizing.sizeM
                color: Qt.alpha("white", 0.08)
            }

            MultiEffect {
                anchors.fill: parent
                source: trackArt
                maskEnabled: true
                maskSource: trackArtMask
            }
        }

        ColumnLayout {
            // Layout.preferredHeight: Sizing.mediaImageSize
            Layout.fillHeight: true
            // Layout.preferredWidth: root.dataWidth
            Layout.fillWidth: true
            spacing: 0

            Binding on Layout.preferredHeight {
                when: root.fixedSize
                value: Sizing.mediaImageSize
            }

            Binding on Layout.preferredWidth {
                when: root.fixedSize
                value: root.dataWidth
            }

            StyleText {
                Layout.fillWidth: true
                text: playerData.trackTitle
                elide: Text.ElideRight
                font.pixelSize: Sizing.sizeL
                bold: true
            }

            StyleText {
                Layout.fillWidth: true
                text: playerData.trackAlbum
                visible: text != ""
                elide: Text.ElideRight
                color: Colors.secondaryText
                italic: true
            }

            StyleText {
                Layout.fillWidth: true
                Layout.topMargin: Sizing.sizeXXS
                text: playerData.trackArtist
                elide: Text.ElideRight
                color: Colors.secondaryText
            }

            Item {
                Layout.fillHeight: true
            }

            RowLayout {
                Layout.bottomMargin: Sizing.sizeMicro
                spacing: Sizing.sizeMicro

                Item {
                    Layout.fillWidth: true
                }

                IconButton {
                    iconName: "previous"
                    onTapped: playerData.previous()
                    enabled: playerData.canGoPrevious
                }

                IconButton {
                    iconName: playerData.playing ? "pause" : "play"
                    onTapped: playerData.togglePlaying()
                    enabled: playerData.canTogglePlaying
                }

                IconButton {
                    iconName: "next"
                    onTapped: playerData.next()
                    enabled: playerData.canGoNext
                }

                Item {
                    Layout.fillWidth: true
                }
            }

            StyleText {
                text: `${playerData.positionFmt} / ${playerData.lengthFmt}`
                color: Colors.secondaryText
            }

            StyleSliderStatic {
                Layout.fillWidth: true

                from: 0
                to: playerData.length
                value: playerData.position
            }
        }
    }
}
