import Quickshell
import QtQuick
import Quickshell.Io
import qs.Components
import qs.Settings

Item {
    id: btModule
    property var shell
    property var devices: []

    width: btRow.width
    height: btRow.height

    property string dataFile: "/tmp/bluetooth_batteries"

    function parseDevices() {
        const raw = btFile.text().trim()
        console.log("BT RAW:", raw)

        const lines = raw.split("\n").filter(l => l !== "")
        const list = []

        for (let l of lines) {
            const parts = l.split("|")
            if (parts.length < 3) continue

            const type = parts[0].trim()
            const name = parts[1].trim()
            const battery = parts[2].trim()

            list.push({
                type: type,
                name: name,
                battery: battery
            })
        }

        devices = list
        console.log("BT devices:", JSON.stringify(devices))
    }

    FileView {
        id: btFile
        path: dataFile
        watchChanges: true
        blockLoading: true

        onLoaded: {
            parseDevices()
        }

        onFileChanged: {
            btFile.reload()
            parseDevices()
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            btFile.reload()
            parseDevices()
        }
    }

    Row {
        id: btRow
        spacing: 6
        anchors.verticalCenter: parent.verticalCenter

        Repeater {
            model: devices

            delegate: PillIndicator {
                width: 24
                height: 24

                icon: {
                    if (modelData.type === "input-keyboard") return "keyboard"
                    else if (modelData.type === "audio-headset") return "headset"
                    else return "bluetooth"
                }

                pillColor: Theme.surfaceVariant
                iconCircleColor: Theme.accentPrimary
                iconTextColor: Theme.backgroundPrimary
                textColor: Theme.textPrimary

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: tooltip.tooltipVisible = true
                    onExited: tooltip.tooltipVisible = false
                }

                StyledTooltip {
                    id: tooltip
                    text: modelData.name + " " + modelData.battery + "%"
                    tooltipVisible: false
                    targetItem: parent
                    delay: 200
                }
            }
        }
    }

    Component.onCompleted: parseDevices()
}
