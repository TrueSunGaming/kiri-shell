import Quickshell
import Quickshell.Io
import qs.data

Scope {
    id: root

    required property string scriptID

    readonly property var jsonData: Scripts.getScript(scriptID)
    readonly property bool exists: jsonData != null

    readonly property string name: jsonData?.name ?? "Unnamed script"
    readonly property string comment: jsonData?.description ?? ""
    readonly property string icon: Icons.getIcon(jsonData?.icon ?? "") || "terminal"
    readonly property string command: jsonData?.command ?? `./${scriptID}.sh`
    readonly property string workingDirectory: jsonData?.workingDirectory ?? `${Quickshell.shellDir}/scripts`
    readonly property var environment: jsonData?.environment ?? ({})

    Process {
        id: process
        command: ["sh", "-c", root.command]
        workingDirectory: root.workingDirectory
        environment: root.environment
    }

    function run(): void {
        process.exec({});
    }
}
