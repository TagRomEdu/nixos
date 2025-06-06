import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.UPower

RowLayout {
    id: root
    required property var shell

    spacing: 8
    signal performanceActionRequested(string action)
    signal mouseChanged(bool containsMouse)

    readonly property bool containsMouse: performanceButton.containsMouse ||
                                         balancedButton.containsMouse ||
                                         powerSaverButton.containsMouse

    readonly property bool upowerReady: typeof PowerProfiles !== 'undefined' && PowerProfiles
    readonly property bool powerProfileDefined: typeof PowerProfile !== 'undefined'
    readonly property int currentProfile: upowerReady ? PowerProfiles.profile : -1

    onContainsMouseChanged: root.mouseChanged(containsMouse)

    opacity: visible ? 1 : 0
    Behavior on opacity {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    // Helper function to safely set profile
    function setProfile(profile, action) {
        if (root.upowerReady && root.powerProfileDefined) {
            PowerProfiles.profile = profile
            root.performanceActionRequested(action)
        } else {
            console.warn("PowerProfiles or PowerProfile not available")
        }
    }

    // Performance Profile Button
    SystemButton {
        id: performanceButton
        Layout.fillHeight: true
        Layout.fillWidth: true
        shell: root.shell
        iconText: "󰓅"

        isActive: root.upowerReady && root.powerProfileDefined &&
                  root.currentProfile === PowerProfile.Performance

        onClicked: setProfile(PowerProfile.Performance, "performance")

        onMouseChanged: function(containsMouse) {
            if (!containsMouse && !root.containsMouse) root.mouseChanged(false)
        }
    }

    // Balanced Profile Button
    SystemButton {
        id: balancedButton
        Layout.fillHeight: true
        Layout.fillWidth: true
        shell: root.shell
        iconText: "󰾅"

        isActive: root.upowerReady && root.powerProfileDefined &&
                  root.currentProfile === PowerProfile.Balanced

        onClicked: setProfile(PowerProfile.Balanced, "balanced")

        onMouseChanged: function(containsMouse) {
            if (!containsMouse && !root.containsMouse) root.mouseChanged(false)
        }
    }

    // Power Saver Profile Button
    SystemButton {
        id: powerSaverButton
        Layout.fillHeight: true
        Layout.fillWidth: true
        shell: root.shell
        iconText: "󰌪"

        isActive: root.upowerReady && root.powerProfileDefined &&
                  root.currentProfile === PowerProfile.PowerSaver

        onClicked: setProfile(PowerProfile.PowerSaver, "powersaver")

        onMouseChanged: function(containsMouse) {
            if (!containsMouse && !root.containsMouse) root.mouseChanged(false)
        }
    }

    Component.onCompleted: {
        Qt.callLater(() => {
            if (!root.upowerReady) {
                console.warn("UPower service not ready - performance controls may not work correctly")
            }
        })
    }
}
