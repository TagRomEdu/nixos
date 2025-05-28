pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    id: root
    
    // Individual process objects as properties
    property Process shutdownProcess: Process {
        command: ["shutdown", "-h", "now"]
    }
    
    property Process rebootProcess: Process {
        command: ["reboot"]
    }
    
    property Process lockProcess: Process {
        command: ["hyprlock"]
    }
    
    property Process logoutProcess: Process {
        command: ["loginctl", "terminate-user", "$USER"]
    }
    
    property Process pavucontrolProcess: Process {
        command: ["pavucontrol"]
    }
    
    // Convenience methods for common system commands
    function shutdown() {
        console.log("Executing shutdown command")
        shutdownProcess.running = true
    }
    
    function reboot() {
        console.log("Executing reboot command")
        rebootProcess.running = true
    }
    
    function lock() {
        console.log("Executing lock command")
        lockProcess.running = true
    }
    
    function logout() {
        console.log("Executing logout command")
        logoutProcess.running = true
    }
    
    function openPavuControl() {
        console.log("Opening PavuControl")
        pavucontrolProcess.running = true
    }
    
    // Check if a process is running
    function isShutdownRunning() { return shutdownProcess.running }
    function isRebootRunning() { return rebootProcess.running }
    function isLockRunning() { return lockProcess.running }
    function isLogoutRunning() { return logoutProcess.running }
    function isPavuControlRunning() { return pavucontrolProcess.running }
    
    // Stop processes (mainly useful for long-running ones)
    function stopPavuControl() {
        pavucontrolProcess.running = false
    }
}