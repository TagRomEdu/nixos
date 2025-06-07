import Quickshell.Io
import QtQuick
import QtQuick.Controls
import "root:/Data/" as Data

Rectangle {
    id: root
    required property var shell
    required property url avatarSource
    property string userName: ""        // will be set by process output
    property string userInfo: ""        // will hold uptime string

    property bool isActive: false
    property bool isHovered: false      // track hover state

    radius: 12
    width: 220
    height: 80

    color: {
        if (isActive) {
            return isHovered ?
                   Qt.lighter(shell.accentColor, 1.1) :
                   Qt.rgba(shell.accentColor.r, shell.accentColor.g, shell.accentColor.b, 0.3)
        } else {
            return isHovered ?
                   Qt.lighter(shell.accentColor, 1.2) :
                   Qt.lighter(shell.bgColor, 1.15)
        }
    }

    border.width: isActive ? 2 : 1
    border.color: isActive ? shell.accentColor : Qt.lighter(shell.bgColor, 1.3)

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
            //radius: width / 2
            clip: true
            border.color: shell.accentColor
            border.width: 3

            Image {
                anchors.fill: parent
                anchors.margins: 2
                source: Data.Settings.avatarSource
                fillMode: Image.PreserveAspectCrop
                cache: false
            }
        }

        Column {
            spacing: 4
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: root.userName === "" ? "Loading..." : root.userName
                font.pixelSize: 16
                font.bold: true
                color: isHovered || root.isActive ? "#ffffff" : shell.accentColor
                elide: Text.ElideRight
                maximumLineCount: 1
            }

            Text {
                text: root.userInfo === "" ? "Loading uptime..." : root.userInfo
                font.pixelSize: 11
                font.bold: true
                color: isHovered || root.isActive ? "#cccccc" : Qt.lighter(shell.accentColor, 1.6)
                elide: Text.ElideRight
                maximumLineCount: 1
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
