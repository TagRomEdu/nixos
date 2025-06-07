import QtQuick
import QtQuick.Controls

Item {
    id: root
    required property var shell
    required property bool isRecording

    width: 360
    height: isRecording ? (userProfile.height + recordingButton.height + 36) : Screen.height / 2
    visible: false

    anchors.top: parent.top
    anchors.right: parent.right
    anchors.topMargin: 8
    x: visible ? 0 : width
    opacity: 1

    signal recordingRequested()
    signal stopRecordingRequested()
    signal systemActionRequested(string action)
    signal performanceActionRequested(string action)

    Rectangle {
        id: mainContainer
        anchors.fill: parent
        radius: 18
        color: shell.bgColor
        border.width: 3
        border.color: shell.accentColor

        Rectangle {
            anchors.fill: parent
            anchors.margins: -3
            radius: parent.radius + 3
            color: Qt.darker(shell.bgColor, 1.05)
            z: -1
            opacity: 0.3
        }
    }

    property bool isHovered: slideBarMouseArea.containsMouse || 
                            recordingButton.containsMouse || 
                            systemControls.containsMouse || 
                            performanceControls.containsMouse ||
                            userProfile.isHovered

    onIsHoveredChanged: {
        if (isHovered) {
            hideTimer.stop()
        } else {
            hideTimer.start()
        }
    }

    MouseArea {
        id: slideBarMouseArea
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true
    }

    Timer {
        id: hideTimer
        interval: 300
        repeat: false
        onTriggered: {
            if (root.x !== width) {
                slideOutAnimation.start()
            } else {
                root.visible = false
            }
        }
    }

    // Using regular Column here for more precise control
    Column {
        anchors.fill: parent
        anchors.margins: 18
        spacing: root.isRecording ? 0 : 28  // Adjust spacing as needed

        UserProfile {
            id: userProfile
            width: parent.width
            height: 80
            shell: root.shell
        }

        RecordingButton {
            id: recordingButton
            width: parent.width
            height: 48
            shell: root.shell
            isRecording: root.isRecording

            onRecordingRequested: root.recordingRequested()
            onStopRecordingRequested: root.stopRecordingRequested()
        }

        Text {
            id: performanceLabel
            width: parent.width
            text: "PERFORMANCE"
            color: shell.accentColor
            font.pixelSize: 11
            font.weight: Font.DemiBold
            font.letterSpacing: 1.2
            horizontalAlignment: Text.AlignCenter
            visible: !root.isRecording
        }

        PerformanceControls {
            id: performanceControls
            width: parent.width
            height: 52
            visible: !root.isRecording
            shell: root.shell
            onPerformanceActionRequested: function(action) { root.performanceActionRequested(action) }
        }

        Text {
            id: systemLabel
            width: parent.width
            text: "SYSTEM"
            color: shell.accentColor
            font.pixelSize: 11
            font.weight: Font.DemiBold
            font.letterSpacing: 1.2
            horizontalAlignment: Text.AlignCenter
            visible: !root.isRecording
        }

        SystemControls {
            id: systemControls
            width: parent.width
            height: 52
            visible: !root.isRecording
            shell: root.shell
            onSystemActionRequested: function(action) { root.systemActionRequested(action) }
        }
    }

    function show() {
        x = width
        opacity = 1
        visible = true
        slideInAnimation.start()
        hideTimer.stop()
    }

    function hide() {
        if (visible && x === 0) {
            slideOutAnimation.start()
        }
    }

    PropertyAnimation {
        id: slideInAnimation
        target: root
        property: "x"
        from: width
        to: 0
        duration: 350
        easing.type: Easing.OutCubic
        onStarted: root.opacity = 1
    }

    ParallelAnimation {
        id: slideOutAnimation

        PropertyAnimation {
            target: root
            property: "x"
            to: width
            duration: 300
            easing.type: Easing.InCubic
        }

        PropertyAnimation {
            target: root
            property: "opacity"
            to: 0
            duration: 300
            easing.type: Easing.InCubic
        }

        onFinished: {
            root.visible = false
            root.opacity = 1
        }
    }
}