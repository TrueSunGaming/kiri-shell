import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import qs.services

Scope {
    required property MprisPlayer player

    function formatLength(totalSeconds: real): string {
        const roundedSeconds = Math.round(totalSeconds);
        const hours = Math.floor(roundedSeconds / 3600);
        const minutes = Math.floor(roundedSeconds % 3600 / 60);
        const seconds = roundedSeconds % 60

        const paddedMin = minutes.toString().padStart(2, "0");
        const paddedSec = seconds.toString().padStart(2, "0");

        if (hours > 0) return `${hours}:${paddedMin}:${paddedSec}`;
        return `${minutes}:${paddedSec}`;
    }

    readonly property real position: player?.position ?? 0
    readonly property string positionFmt: formatLength(position)
    readonly property real length: player?.length ?? 0
    readonly property string lengthFmt: formatLength(length)

    readonly property DesktopEntry desktopEntry: player ? Apps.heuristicLookup(player.desktopEntry) : null
    readonly property string appName: (desktopEntry?.name || player?.identity) ?? ""
    readonly property string appIcon: Quickshell.iconPath(desktopEntry?.icon, true)

    readonly property string trackTitle: player?.trackTitle || "[Unknown Title]"
    readonly property string trackAlbum: player?.trackAlbum ?? ""
    readonly property string trackArtist: player?.trackArtist || "[Unknown Artist]"
    readonly property string trackArtUrlRaw: player?.trackArtUrl ?? ""
    readonly property url trackArtUrl: trackArtUrlRaw ? Qt.url(trackArtUrlRaw) : ""

    readonly property bool playing: player?.isPlaying ?? false
    readonly property bool canTogglePlaying: player ? (playing ? player.canPause : player.canPlay) : false
    function togglePlaying(): void {
        if (!canTogglePlaying) return;
        player.isPlaying = !player.isPlaying;
    }

    readonly property bool canGoPrevious: player?.canGoPrevious ?? false
    function previous(): void {
        if (canGoPrevious) player.previous();
    }

    readonly property bool canGoNext: player?.canGoNext ?? false
    function next(): void {
        if (canGoNext) player.next();
    }

    FrameAnimation {
        running: player?.isPlaying ?? false
        onTriggered: player?.positionChanged()
    }
}
