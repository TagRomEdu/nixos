import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "root:/Data" as Data

Rectangle {
    id: root
    required property var shell
    required property bool isRecording
    radius: 20
    
    signal recordingRequested()
    signal stopRecordingRequested()
    signal mouseChanged(bool containsMouse)
    
    color: Data.Colors.accentColor
    
    property bool isHovered: mouseArea.containsMouse
    readonly property alias containsMouse: mouseArea.containsMouse
    
    Behavior on scale {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
    scale: isHovered ? 1.03 : 1.0
    
    // Subtle pulsing when recording
    SequentialAnimation {
        running: isRecording
        loops: Animation.Infinite
        
        PropertyAnimation {
            target: root
            property: "opacity"
            to: 0.8
            duration: 1200
            easing.type: Easing.InOutSine
        }
        PropertyAnimation {
            target: root
            property: "opacity"
            to: 1.0
            duration: 1200
            easing.type: Easing.InOutSine
        }
    }
    
    RowLayout {
        anchors.centerIn: parent
        spacing: 10
        
        Text {
            text: isRecording ? "stop_circle" : "radio_button_unchecked"
            font.family: "Material Symbols Outlined"
            font.pixelSize: 16
            color: "#ffffff"
            
            Layout.alignment: Qt.AlignVCenter
            
            scale: root.isHovered ? 1.1 : 1.0
            Behavior on scale {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutBack
                }
            }
        }
        
        Label {
            text: isRecording ? "Stop Recording" : "Start Recording"
            font.pixelSize: 13
            font.weight: Font.Medium
            color: "#ffffff"
            
            // Remove anchors.verticalCenter, use Layout.alignment instead
            Layout.alignment: Qt.AlignVCenter
        }
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        
        onContainsMouseChanged: root.mouseChanged(containsMouse)
        
        onClicked: {
            if (isRecording) {
                root.stopRecordingRequested()
            } else {
                root.recordingRequested()
            }
        }
    }
}