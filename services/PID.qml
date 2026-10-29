pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var result: ({})

    Process {
        id: pidFinder

        property int targetPID

        command: ["sh", "-c", `awk '{print "${targetPID}:" $4}' /proc/${targetPID}/stat`]

        stdout: StdioCollector {
            onStreamFinished: {
                const split = text.split(":");
                root.result[parseInt(split[0])] = parseInt(split[1]);
                root.resultChanged();
            }
        }
    }

    function loadPPID(pid: int): void {
        pidFinder.targetPID = pid;
        pidFinder.running = true;
    }
}
