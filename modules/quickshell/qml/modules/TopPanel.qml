import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import "root:/settings" as Settings
import "root:/Core/" as Core
import "root:/widgets/panel" as Modules

Item {
    id: topPanelRoot
    required property var shell

    anchors.fill: parent
    visible: true

    property bool isRecording: false
    property var recordingProcess: null
    property string lastError: ""

    signal slideBarVisibilityChanged(bool visible)

    function triggerTopPanel() {
        panel.show()
    }

    Modules.TopPanelTrigger {
        id: topPanelTrigger
        onTriggered: triggerTopPanel()
    }

    Modules.Panel {
        id: panel
        shell: topPanelRoot.shell
        isRecording: topPanelRoot.isRecording

        anchors.top: topPanelRoot.top
        anchors.right: topPanelRoot.right
        anchors.topMargin: 8
        anchors.rightMargin: 8

        onVisibleChanged: slideBarVisibilityChanged(visible)

        onRecordingRequested: startRecording()
        onStopRecordingRequested: {
            stopRecording()
            panel.hide()
        }
        onSystemActionRequested: function(action) {
            performSystemAction(action)
            panel.hide()
        }
        onPerformanceActionRequested: function(action) {
            performPerformanceAction(action)
            panel.hide()
        }
    }

    function startRecording() {
        var currentDate = new Date()
        var hours = String(currentDate.getHours()).padStart(2, '0')
        var minutes = String(currentDate.getMinutes()).padStart(2, '0')
        var day = String(currentDate.getDate()).padStart(2, '0')
        var month = String(currentDate.getMonth() + 1).padStart(2, '0')
        var year = currentDate.getFullYear()

        var filename = hours + "-" + minutes + "-" + day + "-" + month + "-" + year + ".mp4"
        var outputPath = Settings.Config.videoPath + filename
        var command = "gpu-screen-recorder -w portal -f 60 -a default_output -o " + outputPath

        var qmlString = 'import Quickshell.Io; Process { command: ["sh", "-c", "' + command + '"]; running: true }'

        recordingProcess = Qt.createQmlObject(qmlString, topPanelRoot)
        isRecording = true
    }

    function stopRecording() {
        if (recordingProcess && isRecording) {
            var stopQmlString = 'import Quickshell.Io; Process { command: ["sh", "-c", "pkill -SIGINT -f \'gpu-screen-recorder.*portal\'"]; running: true; onExited: function() { destroy() } }'

            var stopProcess = Qt.createQmlObject(stopQmlString, topPanelRoot)

            var cleanupTimer = Qt.createQmlObject('import QtQuick; Timer { interval: 3000; running: true; repeat: false }', topPanelRoot)
            cleanupTimer.triggered.connect(function() {
                if (recordingProcess) {
                    recordingProcess.running = false
                    recordingProcess.destroy()
                    recordingProcess = null
                }

                var forceKillQml = 'import Quickshell.Io; Process { command: ["sh", "-c", "pkill -9 -f \'gpu-screen-recorder.*portal\' 2>/dev/null || true"]; running: true; onExited: function() { destroy() } }'
                var forceKillProcess = Qt.createQmlObject(forceKillQml, topPanelRoot)

                cleanupTimer.destroy()
            })
        }
        isRecording = false
    }

    function performSystemAction(action) {
        switch(action) {
            case "lock":
                Core.ProcessManager.lock()
                break
            case "reboot":
                Core.ProcessManager.reboot()
                break
            case "shutdown":
                Core.ProcessManager.shutdown()
                break
        }
    }

    function performPerformanceAction(action) {
        // Performance actions handled silently
    }
}
