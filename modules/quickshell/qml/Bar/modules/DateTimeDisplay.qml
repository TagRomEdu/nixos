import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Column {
    required property var shell  // Shell object providing time, date, colors
    
    width: 80
    spacing: 2
    Layout.alignment: Qt.AlignVCenter  // Center vertically in layout

    Label {
        id: timeLabel
        width: parent.width
        text: shell.time  // Current time string from shell
        color: shell.accentColor  // Accent color from shell
        font.family: "FiraCode Nerd Font"
        font.pixelSize: 14
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        
        // Subtle pulsing scale animation synced with time update (1 minute cycle)
        SequentialAnimation on scale {
            loops: Animation.Infinite
            NumberAnimation {
                to: 1.02
                duration: 60000  // Pulse expands slowly over 1 minute
                easing.type: Easing.InOutSine
            }
            NumberAnimation {
                to: 1.0
                duration: 200  // Snap back quickly
                easing.type: Easing.OutCubic
            }
            PauseAnimation { duration: 59800 }  // Pause before next pulse
        }
    }

    Label {
        width: parent.width
        text: shell.date  // Current date string from shell
        color: Qt.lighter(shell.fgColor, 1.2)  // Slightly lighter than foreground color
        font.family: "FiraCode Nerd Font"
        font.pixelSize: 10
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        
        // Fade-in effect on component load
        opacity: 0
        Component.onCompleted: opacity = 1
        Behavior on opacity {
            NumberAnimation {
                duration: 800
                easing.type: Easing.OutCubic
            }
        }
    }
}
