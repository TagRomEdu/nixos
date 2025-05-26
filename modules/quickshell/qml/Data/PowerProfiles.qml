pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: powerProfiles

    // Current active profile
    property string currentProfile: "unknown"
    onCurrentProfileChanged: console.log("Profile changed to:", currentProfile)

    // Available profiles
    readonly property var availableProfiles: ["performance", "balanced", "power-saver"]

    // Track active processes to prevent memory leaks
    property var activeProcesses: []

    // Initialize by getting current profile
    Component.onCompleted: getCurrentProfile()

    // Get current power profile
    function getCurrentProfile() {
        
        var proc = Qt.createQmlObject(`
            import QtQuick
            import Quickshell
            import Quickshell.Io
            Process {
                command: ["powerprofilesctl", "get"]
                running: true
                onRunningChanged: if (!running) destroy()
                stdout: SplitParser {
                    onRead: function(data) {
                        var profile = data.trim().toLowerCase();
                        if (powerProfiles.availableProfiles.includes(profile)) {
                            powerProfiles.currentProfile = profile;
                        }
                    }
                }
            }
        `, powerProfiles);
        
        activeProcesses.push(proc);
    }

    // Set power profile
    function setProfile(profile) {
        if (!availableProfiles.includes(profile)) {
            console.error("Invalid power profile:", profile);
            return;
        }

        cleanupProcesses();
        
        var proc = Qt.createQmlObject(`
            import QtQuick
            import Quickshell
            import Quickshell.Io
            Process {
                command: ["powerprofilesctl", "set", "${profile}"]
                running: true
                onRunningChanged: if (!running) destroy()
                stdout: SplitParser {
                    onRead: function(data) {
                        if (data.includes("activated")) {
                            powerProfiles.currentProfile = "${profile}";
                            // Verify the change took effect
                            powerProfiles.getCurrentProfile();
                        }
                    }
                }
            }
        `, powerProfiles);
        
        activeProcesses.push(proc);
    }

    // Convenience functions
    function setPerformance() { setProfile("performance"); }
    function setBalanced() { setProfile("balanced"); }
    function setPowerSaver() { setProfile("power-saver"); }
}