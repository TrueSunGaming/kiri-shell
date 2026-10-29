import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import Quickshell.Wayland
import qs.components
import qs.data
import qs.services

MenuBarPopup {
    id: root
    property bool osdActive

    Timer {
        id: changeTimeout
        interval: 1000
        onTriggered: root.osdActive = false
    }

    readonly property bool anyHover: hoverHandler.hovered

    onAnyHoverChanged: {
        if (!osdActive) return;
        if (anyHover) changeTimeout.stop();
        else changeTimeout.restart();
    }

    Connections {
        target: Audio
        function onVolumeChanged(): void {
            if (root.menuBar.screen.name != Hyprland.focusedMonitor.name) return;
            root.osdActive = true;
            if (!anyHover) changeTimeout.restart();
        }
    }

    popupContent: ColumnLayout {
        ColumnLayout {
            Repeater {
                model: ScriptModel {
                    values: [...Audio.sinks].sort((a, b) => Audio.sink == a ? -1 : 0)
                }

                delegate: PwNodeDisplay {
                    required property PwNode modelData
                    node: modelData
                }
            }
        }

        Rectangle {
            Layout.preferredHeight: 1
            Layout.fillWidth: true
            color: Colors.secondaryText
        }

        ColumnLayout {
            Repeater {
                model: ScriptModel {
                    values: [...Audio.streams]
                }

                delegate: PwNodeDisplay {
                    required property PwNode modelData
                    node: modelData
                }
            }
        }
    }

    component PwNodeDisplay: ColumnLayout {
        id: nodeDisplay

        required property PwNode node
        readonly property PwNodeAudio nodeAudio: node.audio

        StyleText {
            Layout.preferredWidth: sinkData.width

            bold: true
            text: (nodeDisplay.node.isStream ? Audio.getNodeToplevel(modelData)?.title ?? null : null) ?? Audio.getNodeName(nodeDisplay.node)
            elide: Text.ElideMiddle
            color: Audio.sink == nodeDisplay.node ? Colors.accent : Colors.text
        }

        RowLayout {
            id: sinkData

            StyleText {
                id: volumeText

                TextMetrics {
                    id: metrics100
                    font: volumeText.font
                    text: "100%"
                }

                Layout.preferredWidth: metrics100.width
                text: `${Audio.getNodeVolume(nodeDisplay.nodeAudio)}%`
            }

            StyleSlider {
                Layout.fillWidth: true

                from: 0
                to: 100
                stepSize: 5
                value: Audio.getNodeVolume(nodeDisplay.nodeAudio)

                onMoved: {
                    Audio.setNodeVolume(nodeDisplay.nodeAudio, value);
                    value = Qt.binding(() => Audio.getNodeVolume(nodeDisplay.nodeAudio));
                }
            }
        }
    }
}
