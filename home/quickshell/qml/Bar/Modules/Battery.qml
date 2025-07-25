import QtQuick
import Quickshell.Io
import qs.Components
import qs.Settings

Item {
    id: batteryDisplay
    property int batteryLevel: -1

    width: pill.width
    height: pill.height

    function batteryIcon(level, charging) {
        if (charging)
            return "battery_charging_full"
        if (level < 15) return "battery_alert"
        else if (level < 40) return "battery_20"
        else if (level < 70) return "battery_50"
        else if (level < 90) return "battery_80"
        else return "battery_full"
    }


    FileView {
        id: batteryStatusFile
        path: "/sys/class/power_supply/BAT0/status"
        watchChanges: true
        blockLoading: true

        onLoaded: batteryStatusFile.reload()
        onFileChanged: batteryStatusFile.reload()
    }

    FileView {
        id: batteryFile
        path: "/sys/class/power_supply/BAT0/capacity"   // Твой файл с уровнем батареи
        watchChanges: true
        blockLoading: true

        onLoaded: updateBatteryLevel()
        onFileChanged: {
            batteryFile.reload()
            updateBatteryLevel()
        }

        function updateBatteryLevel() {
            const val = parseInt(batteryFile.text())
            console.log("Raw battery value:", batteryFile.text(), "Parsed:", val);       
            if (!isNaN(val) && val !== batteryDisplay.batteryLevel) {
                batteryDisplay.batteryLevel = val
                console.log("Battery updated to:", batteryDisplay.batteryLevel);
            }
        }
    }

    Timer {
        interval: 10000 // 10 секунд
        running: true
        repeat: true
        triggeredOnStart: false
        onTriggered: {
            batteryFile.reload()
            updateBatteryLevel()
        }
    }

    PillIndicator {
        property int batteryLevel: batteryDisplay.batteryLevel
        id: pill
        icon: batteryIcon(batteryLevel, batteryStatusFile.text().trim() === "Charging")
        text: batteryDisplay.batteryLevel >= 0 ? batteryLevel + "%" : ""
        pillColor: Theme.surfaceVariant
        iconCircleColor: Theme.accentPrimary
        iconTextColor: Theme.backgroundPrimary
        textColor: Theme.textPrimary

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: batteryTooltip.tooltipVisible = true
            onExited: batteryTooltip.tooltipVisible = false
        }

        StyledTooltip {
            id: batteryTooltip
            text: "Battery level: " + batteryLevel + "%"
            tooltipVisible: false
            targetItem: pill
            delay: 200
        }
    }

    Component.onCompleted: {
        if (batteryLevel >= 0) {
            pill.show()
        }
    }
}
