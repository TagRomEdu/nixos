import QtQuick
import Quickshell.Io
import qs.Settings
import qs.Components

Item {
    id: brightnessDisplay
    property var shell
    property int brightness: -1

    width: pill.width
    height: pill.height

    FileView {
        id: brightnessFile
        path: "/tmp/brightness_osd_level"
        watchChanges: true
        blockLoading: true

        onLoaded: updateBrightness()
        onFileChanged: {
            brightnessFile.reload()
            updateBrightness()
        }

        function updateBrightness() {
            const val = parseInt(brightnessFile.text())
            if (!isNaN(val) && val !== brightnessDisplay.brightness) {
                brightnessDisplay.brightness = val
                pill.text = brightness + "%"
                pill.show()
            }
        }
    }

    PillIndicator {
        id: pill
        icon: "brightness_high"
        text: brightness >= 0 ? brightness + "%" : ""
        pillColor: Theme.surfaceVariant
        iconCircleColor: Theme.accentPrimary
        iconTextColor: Theme.backgroundPrimary
        textColor: Theme.textPrimary
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: brightnessTooltip.tooltipVisible = true
            onExited: brightnessTooltip.tooltipVisible = false
            onWheel: (wheel) => {
                if (!shell) return;
                if (wheel.angleDelta.y > 0) {
                    shell.updateBrightness("up");
                } else if (wheel.angleDelta.y < 0) {
                    shell.updateBrightness("down");
                }
            }  
        }

        StyledTooltip {
            id: brightnessTooltip
            text: "Brightness: " + brightness + "%"
            tooltipVisible: false
            targetItem: pill
            delay: 200
        }
    }

    Component.onCompleted: {
        if (brightness >= 0) {
            pill.show()
        }
    }
}
