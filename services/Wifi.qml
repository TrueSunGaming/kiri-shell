pragma Singleton

import Quickshell
import Quickshell.Networking

Singleton {
    readonly property NetworkDevice connectedDevice: Networking.devices.values.find((d) => d.connected) ?? null
    readonly property Network connectedNetwork: connectedDevice?.networks.values.find((n) => n.connected) ?? null

    readonly property int connectivity: Networking.connectivity

    readonly property string icon: {
        switch (connectivity) {
            case NetworkConnectivity.Unknown:
            return "wifi_question";
            case NetworkConnectivity.None:
            return "wifi_off";
            case NetworkConnectivity.Portal:
            case NetworkConnectivity.Limited:
            return "wifi_alert";
            case NetworkConnectivity.Full:
            return "wifi";
        }
    }

    readonly property string connectionStateText: {
        if (!connectedNetwork) return "";
        return ConnectionState.toString(connectedNetwork.state);
    }

    readonly property string statusText: {
        if (connectionStateText) return `${connectedNetwork.name} (${connectionStateText})`;

        switch (connectivity) {
            case NetworkConnectivity.Unknown:
            return "Unknown";
            case NetworkConnectivity.None:
            return "Disconnected";
            case NetworkConnectivity.Portal:
            case NetworkConnectivity.Limited:
            return "Connected, no internet";
            case NetworkConnectivity.Full:
            return "Connected";
        }
    }
}
