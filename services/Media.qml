pragma Singleton

import Quickshell
import Quickshell.Services.Mpris

Singleton {
    property alias playerModel: players

    ScriptModel {
        id: players
        values: Mpris.players.values.filter((p) => p.trackTitle)
    }

    function getProgress(player: MprisPlayer): real {
        return (player?.position ?? 0) / (player?.length ?? 1);
    }
}
