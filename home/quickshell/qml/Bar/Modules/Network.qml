import Quickshell
import QtQuick
import Quickshell.Io
import qs.Components
import qs.Settings

Item {
    id: networkDisplay
    property string status: "down"
    property string ipAddr: ""
    property string activeIface: ""

    width: pill.width
    height: pill.height

    function isIfaceActive(state) {
        return state === "up" || state === "dormant"
    }

    function updateIP(iface) {
        Quickshell.execDetached(["sh", "-c", "ip -4 addr show " + iface + " | awk '/inet / {print $2}' | cut -d/ -f1 > /tmp/current_ip"], null)
    }

    function updateStatus() {
        const ethState = ethOperstate.text().trim()
        const wifiState = wifiOperstate.text().trim()

        let newStatus = "down"
        let iface = ""

        if (isIfaceActive(ethState)) {
            newStatus = "ethernet"
            iface = "enp0s20f0u8u1"
        } else if (isIfaceActive(wifiState)) {
            newStatus = "wifi"
            iface = "wlp3s0"
        }

        // Если статус или интерфейс не поменялись, ничего не делаем
        if (newStatus === status && iface === activeIface) return

        status = newStatus
        activeIface = iface

        if (status !== "down") {
            updateIP(activeIface)
        } else {
            ipAddr = ""
        }

        pill.show()
        networkTooltip.text = "Network: " + status + " (" + ipAddr + ")"
    }

    FileView {
        id: wifiOperstate
        path: "/sys/class/net/wlp3s0/operstate"
        watchChanges: true
        blockLoading: true
        onLoaded: updateStatus()
        onFileChanged: { wifiOperstate.reload(); updateStatus() }
    }

    FileView {
        id: ethOperstate
        path: "/sys/class/net/enp0s20f0u8u1/operstate"
        watchChanges: true
        blockLoading: true
        onLoaded: updateStatus()
        onFileChanged: { ethOperstate.reload(); updateStatus() }
    }

    FileView {
        id: ipFile
        path: "/tmp/current_ip"
        watchChanges: true
        blockLoading: true

        onLoaded: {
            ipAddr = ipFile.text().trim()
        }
        onFileChanged: {
            ipFile.reload()
            ipAddr = ipFile.text().trim()
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            ethOperstate.reload()
            wifiOperstate.reload()
            updateStatus()
        }
    }

    PillIndicator {
        id: pill
        icon: {
            if (status === "ethernet") return "lan"
            else if (status === "wifi") return "wifi"
            else return "signal_wifi_off"
        }
        text: ipAddr
        pillColor: Theme.surfaceVariant
        iconCircleColor: Theme.accentPrimary
        iconTextColor: Theme.backgroundPrimary
        textColor: Theme.textPrimary
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: networkTooltip.tooltipVisible = true
            onExited: networkTooltip.tooltipVisible = false
        }
        StyledTooltip {
            id: networkTooltip
            text: "Network: " + status + " (" + ipAddr + ")"
            tooltipVisible: false
            targetItem: pill
            delay: 200
        }
    }

    Component.onCompleted: updateStatus()
}

