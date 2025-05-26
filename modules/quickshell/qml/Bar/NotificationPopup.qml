import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.Notifications

Item {
    required property var shell
    property var notificationQueue: []
    property int displayTime: 10000 // 10 seconds
    property int maxWidth: 400
    property int maxNotifications: 5
    property int notificationSpacing: 12
    property int baseNotificationHeight: 70

    required property var notificationServer

    // Store active timers to manage them properly
    property var activeTimers: ({})
    property int lastNotificationTime: 0

    // Improved height calculation with proper bounds
    property int calculatedHeight: {
        let totalHeight = 0;
        let visibleCount = Math.min(notificationQueue.length, maxNotifications);
        
        for (let i = 0; i < visibleCount; i++) {
            let notification = notificationQueue[i];
            let notificationHeight = calculateIndividualHeight(notification);
            totalHeight += notificationHeight;
            
            if (i < visibleCount - 1) {
                totalHeight += notificationSpacing;
            }
        }
        
        return totalHeight + 40; // Increased bottom margin for safety
    }

    // Helper function to calculate individual notification height
    function calculateIndividualHeight(notification) {
        let height = 60; // Minimal base height for header + padding
        
        // Add height for app name (always present)
        height += 18;
        
        // Add height for summary if present
        if (notification?.summary && notification.summary.trim() !== "") {
            height += 20;
        }
        
        // Add height for body if present
        if (notification?.body && notification.body.trim() !== "") {
            // Count actual line breaks in the text
            let bodyText = notification.body.trim();
            let explicitLines = (bodyText.match(/\n/g) || []).length + 1;
            let wrapLines = Math.ceil(bodyText.length / 60);
            let estimatedLines = Math.max(explicitLines, wrapLines);
            height += Math.min(estimatedLines * 18, 80); // Cap at ~4 lines
        }
        
        if (notification?.actions?.length > 0) height += 35;
        
        return height;
    }

    // Timer component for auto-expiry
    Component {
        id: expiryTimerComponent
        Timer {
            property var targetNotification
            interval: displayTime
            running: true
            onTriggered: {
                if (targetNotification && targetNotification.tracked) {
                    console.log("Auto-expiring notification:", targetNotification.summary)
                    targetNotification.expire()
                }
                destroy()
            }
        }
    }

    Connections {
        target: notificationServer
        
        function onNotification(notification) {
            console.log("Multi-notification component received notification:", notification.appName, notification.summary)
            notification.tracked = true
            
            // Mark this as the newest notification
            let currentTime = Date.now()
            notification.arrivalTime = currentTime
            lastNotificationTime = currentTime
            
            notificationQueue.unshift(notification)
            notificationQueueChanged()
            calculatedHeightChanged()
            
            // Create timer for auto-expiry using the notification's expire() method
            let timer = expiryTimerComponent.createObject(parent, {
                "targetNotification": notification
            });
            
            // Store the timer reference using the notification's ID
            activeTimers[notification.id] = timer;
            
            // Listen for the notification's closed signal to remove it from our queue
            notification.closed.connect(function(reason) {
                console.log("Notification closed with reason:", reason, "- removing from queue")
                removeFromQueue(notification.id)
            })
        }
    }

    function removeFromQueue(notificationId) {
        console.log("Removing notification from queue:", notificationId)
        
        // Clean up timer if it exists
        if (activeTimers[notificationId]) {
            activeTimers[notificationId].destroy();
            delete activeTimers[notificationId];
        }
        
        // Remove from queue
        for (let i = 0; i < notificationQueue.length; i++) {
            if (notificationQueue[i].id === notificationId) {
                notificationQueue.splice(i, 1)
                notificationQueueChanged()
                calculatedHeightChanged()
                break
            }
        }
    }

    function dismissNotification(notification) {
        console.log("Manually dismissing notification:", notification.summary)
        // Clean up timer
        if (activeTimers[notification.id]) {
            activeTimers[notification.id].destroy();
            delete activeTimers[notification.id];
        }
        // Use the proper dismiss method
        notification.dismiss()
    }

    // Clean up all timers when component is destroyed
    Component.onDestruction: {
        for (let id in activeTimers) {
            if (activeTimers[id]) {
                activeTimers[id].destroy();
            }
        }
    }

    Column {
        id: notificationColumn
        width: maxWidth
        spacing: notificationSpacing
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 8 // Add some margin from edge

        Repeater {
            model: Math.min(notificationQueue.length, maxNotifications)
            
            delegate: Rectangle {
                id: notificationContainer
                property var notification: notificationQueue[index]
                property bool isNewest: notification.arrivalTime === lastNotificationTime
                
                width: maxWidth
                // Use the helper function for consistent height calculation
                height: calculateIndividualHeight(notification)
                
                // Modern glassmorphism design with accent border
                color: Qt.rgba(0, 0, 0, 0.05)

                radius: 16
                
                // Subtle gradient background
                Rectangle {
                    border.width: 3//yyy
                    border.color: shell.accentColor
                    anchors.fill: parent
                    radius: parent.radius
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.rgba(255, 255, 255, 0.08) }
                        GradientStop { position: 1.0; color: Qt.rgba(255, 255, 255, 0.02) }
                    }
                }
                
                // Backdrop blur effect simulation
                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: shell.bgColor
                    opacity: 0.92
                }

                // Only animate the newest notification with improved initial state
                opacity: isNewest ? 0 : 1
                scale: isNewest ? 0.95 : 1
                
                Component.onCompleted: {
                    if (isNewest) {
                        slideInAnimation.start()
                    }
                }

                ParallelAnimation {
                    id: slideInAnimation
                    NumberAnimation {
                        target: notificationContainer
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 300
                        easing.type: Easing.OutCubic
                    }
                    NumberAnimation {
                        target: notificationContainer
                        property: "scale"
                        from: 0.95
                        to: 1
                        duration: 300
                        easing.type: Easing.OutBack
                        easing.overshoot: 1.1
                    }
                }

                // Hover effect
                MouseArea {
                    id: hoverArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: dismissNotification(notification)
                    z: -1
                    
                    onEntered: hoverAnimation.start()
                    onExited: unhoverAnimation.start()
                }
                
                NumberAnimation {
                    id: hoverAnimation
                    target: notificationContainer
                    property: "scale"
                    to: 1.02
                    duration: 150
                    easing.type: Easing.OutCubic
                }
                
                NumberAnimation {
                    id: unhoverAnimation
                    target: notificationContainer
                    property: "scale"
                    to: 1.0
                    duration: 150
                    easing.type: Easing.OutCubic
                }

                // Content area with minimal margins to prevent empty space
                Item {
                    id: contentArea
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    anchors.topMargin: 12
                    anchors.bottomMargin: 12
                    clip: true
                    
                    ColumnLayout {
                        id: notificationContent
                        anchors.fill: parent
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12

                            Rectangle {
                                width: 28
                                height: 28
                                radius: 14
                                color: Qt.rgba(255, 255, 255, 0.05)
                                border.width: 1
                                border.color: shell.accentColor
                                Layout.alignment: Qt.AlignTop
                                Layout.topMargin: 6 // Better alignment with text content

                                // Try to show image first
                                Image {
                                    id: appImage
                                    source: notification?.image || notification?.appIcon || ""
                                    anchors.fill: parent
                                    anchors.margins: 2
                                    fillMode: Image.PreserveAspectFit
                                    visible: source.toString() !== ""
                                }

                                // Show text fallback if no image
                                Text {
                                    id: fallbackText
                                    anchors.centerIn: parent
                                    text: notification?.appName ? notification.appName.charAt(0).toUpperCase() : "!"
                                    color: shell.accentColor
                                    font.pixelSize: 12
                                    font.bold: true
                                    visible: !appImage.visible
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                RowLayout {
                                    Layout.fillWidth: true
                                    
                                    Text {
                                        text: notification?.appName || "Notification"
                                        color: shell.accentColor
                                        font.bold: true
                                        font.pixelSize: 13
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                    }

                                    Text {
                                        id: timeText
                                        text: Qt.formatDateTime(new Date(), "hh:mm")
                                        color: Qt.lighter(shell.fgColor, 1.6)
                                        font.pixelSize: 10
                                        opacity: 0.8
                                    }
                                    
                                    // Close button
                                    Button {
                                        width: 18
                                        height: 18
                                        flat: true
                                        onClicked: dismissNotification(notification)

                                        background: Rectangle {
                                            radius: 9
                                            color: parent.pressed ? Qt.rgba(255, 255, 255, 0.15) :
                                                   parent.hovered ? Qt.rgba(255, 255, 255, 0.1) : 
                                                   Qt.rgba(255, 255, 255, 0.05)
                                            border.width: 1
                                            border.color: Qt.rgba(255, 255, 255, 0.08)
                                        }

                                        contentItem: Text {
                                            text: "×"
                                            color: shell.fgColor
                                            font.pixelSize: 11
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            opacity: 0.8
                                        }
                                    }
                                }

                                Text {
                                    text: notification?.summary || ""
                                    color: shell.fgColor
                                    font.bold: true
                                    font.pixelSize: 12
                                    wrapMode: Text.Wrap
                                    Layout.fillWidth: true
                                    visible: text !== "" && text.trim() !== ""
                                    maximumLineCount: 2
                                    elide: Text.ElideRight
                                }
                            }
                        }

                        // Body text with plain text format to handle line breaks properly
                        Text {
                            text: notification?.body || ""
                            textFormat: Text.PlainText // Changed from MarkdownText to handle line breaks
                            color: Qt.lighter(shell.fgColor, 1.2)
                            font.pixelSize: 14
                            wrapMode: Text.Wrap
                            Layout.fillWidth: true
                            maximumLineCount: 4
                            elide: Text.ElideRight
                            visible: text !== "" && text.trim() !== ""
                            lineHeight: 1.2
                            Layout.preferredHeight: visible ? implicitHeight : 0 // Only take space when visible
                        }
                    }
                }
            }
        }
    }

    // Enhanced overflow indicator
    Rectangle {
        visible: notificationQueue.length > maxNotifications
        anchors {
            bottom: notificationColumn.bottom
            right: notificationColumn.right
            margins: 12
        }
        width: 70
        height: 28
        radius: 20
        
        // Glassmorphism for overflow indicator too
        color: Qt.rgba(0, 0, 0, 0.2)
        border.width: 1
        border.color: Qt.rgba(255, 255, 255, 0.3)

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: shell.accentColor
            opacity: 0.8
        }

        Text {
            anchors.centerIn: parent
            text: "+" + (notificationQueue.length - maxNotifications)
            color: shell.bgColor
            font.pixelSize: 12
            font.bold: true
        }
    }
}