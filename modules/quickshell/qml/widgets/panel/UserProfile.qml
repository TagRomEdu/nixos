import Quickshell.Io
import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import "root:/settings/" as Settings

Rectangle {
    id: root
    required property var shell
    property url avatarSource: Settings.Config.avatarSource
    property string userName: ""        // will be set by process output
    property string userInfo: ""        // will hold uptime string

    property bool isActive: false
    property bool isHovered: false      // track hover state

    radius: 20
    width: 220
    height: 80

    color: {
        if (isActive) {
            return isHovered ?
                   Qt.lighter(Settings.Colors.accentColor, 1.1) :
                   Qt.rgba(Settings.Colors.accentColor.r, Settings.Colors.accentColor.g, Settings.Colors.accentColor.b, 0.3)
        } else {
            return isHovered ?
                   Qt.lighter(Settings.Colors.accentColor, 1.2) :
                   Qt.lighter(Settings.Colors.bgColor, 1.15)
        }
    }

    border.width: isActive ? 2 : 1
    border.color: isActive ? Settings.Colors.accentColor : Qt.lighter(Settings.Colors.bgColor, 1.3)

    Behavior on color { ColorAnimation { duration: 200; easing.type: Easing.OutCubic } }
    Behavior on border.color { ColorAnimation { duration: 200; easing.type: Easing.OutCubic } }
    scale: isHovered ? 1.05 : 1.0
    Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

    Row {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 12
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            id: avatarCircle
            width: 52
            height: 52
            radius: 20
            clip: true
            border.color: Settings.Colors.accentColor
            border.width: 3
            color: "transparent"

            Image {
                id: avatarImage
                anchors.fill: parent
                anchors.margins: 2
                source: Settings.Config.avatarSource
                fillMode: Image.PreserveAspectCrop
                cache: false
                visible: false  // Hide the original image
            }

            OpacityMask {
                anchors.fill: avatarImage
                source: avatarImage
                maskSource: Rectangle {
                    width: avatarImage.width
                    height: avatarImage.height
                    radius: 18  // Proportionally smaller than parent (48/52 * 20 ≈ 18)
                    visible: false
                }
            }
        }

        Column {
            spacing: 4
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - avatarCircle.width - gifContainer.width - parent.spacing * 2

            Text {
                width: parent.width
                text: root.userName === "" ? "Loading..." : root.userName
                font.pixelSize: 16
                font.bold: true
                color: isHovered || root.isActive ? "#ffffff" : Settings.Colors.accentColor
                elide: Text.ElideRight
                maximumLineCount: 1
            }

            Text {
                width: parent.width
                text: root.userInfo === "" ? "Loading uptime..." : root.userInfo
                font.pixelSize: 11
                font.bold: true
                color: isHovered || root.isActive ? "#cccccc" : Qt.lighter(Settings.Colors.accentColor, 1.6)
                elide: Text.ElideRight
                maximumLineCount: 1
            }
        }

        Rectangle {
            id: gifContainer
            width: 80
            height: 80
            radius: 12
            color: "transparent"
            anchors.verticalCenter: parent.verticalCenter

            Timer {
                id: speedRampTimer
                interval: 100  // Update every 100ms
                repeat: true
                onTriggered: {
                    if (animatedImage.speed < 10.0) {  // Max speed cap
                        animatedImage.speed *= 1.2  // Increase speed by 20% each tick
                    }
                }
            }

            Timer {
                id: decelerationTimer
                interval: 50  // Faster updates for smoother deceleration
                repeat: true
                onTriggered: {
                    if (animatedImage.speed > 0.85) {  // Stop near target speed
                        animatedImage.speed *= 0.9  // Decrease speed by 10% each tick
                    } else {
                        decelerationTimer.stop()
                        animatedImage.speed = 0.8  // Set final speed
                    }
                }
            }

            AnimatedImage {
                id: animatedImage
                source: "root:/Assets/UserProfile.gif"
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                playing: true
                cache: false
                speed: 0.8
                
                Behavior on speed {
                    NumberAnimation { duration: 50 }  // Faster transitions for smoother speed changes
                }
            }

            // Add a mask for rounded corners
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: gifContainer.width
                    height: gifContainer.height
                    radius: gifContainer.radius
                    visible: false
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: root.isHovered = true
        onExited: root.isHovered = false
        onPressed: {
            decelerationTimer.stop()  // Stop deceleration if it's running
            speedRampTimer.start()
        }
        onReleased: {
            speedRampTimer.stop()
            decelerationTimer.start()  // Start smooth deceleration
        }
    }

    Process {
        id: usernameProcess
        running: true
        command: ["sh", "-c", "whoami"]

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: (data) => {
                const line = data.trim();
                if (line.length > 0) {
                    root.userName = line.charAt(0).toUpperCase() + line.slice(1);
                }
            }
        }
    }

    Process {
    id: uptimeProcess
    running: false
    command: ["sh", "-c", "uptime"]

    stdout: SplitParser {
        splitMarker: "\n"
        onRead: (data) => {
            const match = data.match(/up\s+(.*),\s+\d+\s+users/);
            if (match && match[1]) {
                root.userInfo = "Uptime: " + match[1];  // e.g. "Up: 5:54"
            } else {
                root.userInfo = "Uptime unknown";
            }
        }
    }
    }


    Timer {
        id: uptimeTimer
        interval: 60000   // 60 seconds
        running: true
        repeat: true
        onTriggered: {
            uptimeProcess.running = false
            uptimeProcess.running = true
        }
    }

    Component.onCompleted: {
        uptimeProcess.running = true
    }
}
