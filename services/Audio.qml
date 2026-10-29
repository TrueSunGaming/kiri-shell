pragma Singleton

import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property list<PwNode> streams: Pipewire.nodes.values.filter((n) => n.isStream && n.audio);
    readonly property list<PwNode> sinks: Pipewire.nodes.values.filter((n) => n.isSink && !n.isStream && n.audio);
    readonly property PwNodeAudio audio: sink?.audio ?? null

    PwObjectTracker {
        id: sinkTracker
        objects: [root.sink, ...root.streams]
    }

    readonly property int volume: Math.round((audio?.volume ?? 0) * 100)
    readonly property bool muted: audio?.muted ?? false
    readonly property bool silent: volume == 0 || muted
    readonly property string icon: muted ? "volume_off" : (volume == 0 ? "volume_mute" : "volume_on")

    readonly property string sinkName: getNodeName(sink)

    function getNodeName(node: PwNode): string {
        return node?.description || node?.nickname || node?.name || "Unknown"
    }

    function getNodePID(node: PwNode): int {
        return parseInt(node.properties["application.process.id"]);
    }

    function getNodeToplevel(node: PwNode): HyprlandToplevel {
        const pid = getNodePID(node);
        PID.loadPPID(pid);
        void PID.result[pid];
        return Hyprland.toplevels.values.find((t) => t.lastIpcObject?.pid == PID.result[pid]) ?? null;
    }

    function setVolume(vol: real): void {
        if (!audio) return;
        audio.volume = vol / 100;
    }

    function getNodeVolume(nodeAudio: PwNodeAudio): real {
        return Math.round((nodeAudio?.volume ?? 0) * 100);
    }

    function setNodeVolume(nodeAudio: PwNodeAudio, vol: real): void {
        nodeAudio.volume = vol / 100;
    }
}
