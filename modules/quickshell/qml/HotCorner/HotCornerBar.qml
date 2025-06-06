import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import "root:/Data" as Data
import "root:/HotCorner/modules" as Modules

Item {
    required property var shell

    anchors.fill: parent

    // Recording state and process handle
    property bool isRecording: false
    property var recordingProcess: null
    property string lastError: ""
    
    // Signal emitted when SlideBar visibility changes
    signal slideBarVisibilityChanged(bool visible)
    
    // Show slideBar when hot corner triggered externally
    function triggerHotCorner() {
        slideBar.show()
    }

    // Hot corner trigger area at screen corner
    Modules.HotCornerTrigger {
        id: hotCorner
        onTriggered: triggerHotCorner()
    }

    // Sliding control bar anchored to top-right
    Modules.SlideBar {
        id: slideBar
        shell: parent.shell
        isRecording: parent.isRecording
        
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 8
        anchors.rightMargin: 8
        
        // Notify when visibility changes
        onVisibleChanged: slideBarVisibilityChanged(visible)
        
        // Start/stop recording and handle system/performance actions
        onRecordingRequested: startRecording()
        onStopRecordingRequested: {
            stopRecording()
            slideBar.hide()
        }
        onSystemActionRequested: function(action) {
            performSystemAction(action)
            slideBar.hide()
        }
        onPerformanceActionRequested: function(action) {
            performPerformanceAction(action)
            slideBar.hide()
        }
    }

    // Start video recording process with timestamped filename
    function startRecording() {
        var currentDate = new Date()
        var hours = String(currentDate.getHours()).padStart(2, '0')
        var minutes = String(currentDate.getMinutes()).padStart(2, '0')
        var day = String(currentDate.getDate()).padStart(2, '0')
        var month = String(currentDate.getMonth() + 1).padStart(2, '0')
        var year = currentDate.getFullYear()
        
        var filename = hours + "-" + minutes + "-" + day + "-" + month + "-" + year + ".mp4"
        var outputPath = Data.Settings.videoPath + filename
        var command = "gpu-screen-recorder -w portal -f 60 -a default_output -o " + outputPath
        
        var qmlString = 'import Quickshell.Io; Process { command: ["sh", "-c", "' + command + '"]; running: true; onExited: function(exitCode, exitStatus) { console.log("Recording process exited with code:", exitCode) } }'
        
        recordingProcess = Qt.createQmlObject(qmlString, parent)
        isRecording = true
    }
    
    // Stop recording by sending SIGINT, then clean up process
    function stopRecording() {
        if (recordingProcess && isRecording) {
            console.log("Stopping recording")
            
            var stopQmlString = 'import Quickshell.Io; Process { command: ["sh", "-c", "pkill -SIGINT -f \'gpu-screen-recorder.*portal\'"]; running: true; onExited: function(exitCode, exitStatus) { console.log("Stop signal sent, exit code:", exitCode); destroy() } }'
            
            var stopProcess = Qt.createQmlObject(stopQmlString, parent)
            
            // Delay cleanup to ensure recording stops gracefully
            var cleanupTimer = Qt.createQmlObject('import QtQuick; Timer { interval: 3000; running: true; repeat: false }', parent)
            cleanupTimer.triggered.connect(function() {
                console.log("Cleaning up recording process")
                if (recordingProcess) {
                    recordingProcess.running = false
                    recordingProcess.destroy()
                    recordingProcess = null
                }
                
                // Force kill any remaining recorder processes just in case
                var forceKillQml = 'import Quickshell.Io; Process { command: ["sh", "-c", "pkill -9 -f \'gpu-screen-recorder.*portal\' 2>/dev/null || true"]; running: true; onExited: function() { destroy() } }'
                var forceKillProcess = Qt.createQmlObject(forceKillQml, parent)
                
                cleanupTimer.destroy()
            })
        }
        isRecording = false
    }

    // Perform system control actions (lock, reboot, shutdown)
    function performSystemAction(action) {
        switch(action) {
            case "lock":
                Data.ProcessManager.lock()
                break
            case "reboot":
                Data.ProcessManager.reboot()
                break
            case "shutdown":
                Data.ProcessManager.shutdown()
                break
        }
    }
    
    // Placeholder for performance actions
    function performPerformanceAction(action) {
        console.log("Performance action requested:", action)
    }
}
