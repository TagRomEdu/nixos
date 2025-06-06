import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: root
    required property var shell
    required property bool isRecording

    width: 250
    height: isRecording ? 80 : 240
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

    // Main container with border and background
    Rectangle {
        id: mainContainer
        anchors.fill: parent
        radius: 18
        color: shell.bgColor
        border.width: 3
        border.color: shell.accentColor

        // Outer shadow effect
        Rectangle {
            anchors.fill: parent
            anchors.margins: -3
            radius: parent.radius + 3
            color: Qt.darker(shell.bgColor, 1.05)
            z: -1
            opacity: 0.3
        }
    }

    // Track hover over any key controls
    property bool isHovered: slideBarMouseArea.containsMouse || 
                            recordingButton.containsMouse || 
                            systemControls.containsMouse || 
                            performanceControls.containsMouse

    onIsHoveredChanged: {
        if (isHovered) hideTimer.stop()
        else hideTimer.start()
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
            if (root.x !== width) slideOutAnimation.start()
            else root.visible = false
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 14

        RecordingButton {
            id: recordingButton
            Layout.fillWidth: true
            Layout.preferredHeight: 48

            shell: root.shell
            isRecording: root.isRecording

            onRecordingRequested: root.recordingRequested()
            onStopRecordingRequested: root.stopRecordingRequested()
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Qt.darker(shell.bgColor, 1.15)
            opacity: 0.5
            visible: !root.isRecording
        }

        Text {
            Layout.fillWidth: true
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
            Layout.fillWidth: true
            Layout.preferredHeight: 92
            Layout.topMargin: 2

            shell: root.shell
            visible: !root.isRecording

            onSystemActionRequested: action => root.systemActionRequested(action)
        }

        Text {
            Layout.fillWidth: true
            text: "PERFORMANCE"
            color: shell.accentColor
            font.pixelSize: 11
            font.weight: Font.DemiBold
            font.letterSpacing: 1.2
            horizontalAlignment: Text.AlignCenter
            visible: !root.isRecording
            Layout.topMargin: 8
        }

        PerformanceControls {
            id: performanceControls
            Layout.fillWidth: true
            Layout.preferredHeight: 92
            Layout.topMargin: 2

            shell: root.shell
            visible: !root.isRecording

            onPerformanceActionRequested: action => root.performanceActionRequested(action)
        }
    }

    // Show slidebar with animation
    function show() {
        x = width
        opacity = 1
        visible = true
        slideInAnimation.start()
        hideTimer.stop()
    }

    // Hide slidebar with animation
    function hide() {
        if (visible && x === 0) slideOutAnimation.start()
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
