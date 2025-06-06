pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "root:/Data/" as Data

Rectangle {
    id: trayMenu
    width: 180
    height: Math.max(40, listView.contentHeight + 12)
    clip: true
    color: Data.Colors.bgColor
    border.color: Data.Colors.accentColor
    border.width: 3
    radius: 20
    visible: false

    // Only accept mouse events when visible, disables interaction when hidden
    enabled: visible

    property QsMenuHandle menu
    property point triggerPoint: Qt.point(0, 0)
    property Item originalParent

    // Toggle visibility of the menu
    function toggle() {
        if (visible) {
            hide()
        } else {
            show(triggerPoint, originalParent)
        }
    }

    // Hide menu on right-click outside
    function closeOnRightClick() {
        if (visible) {
            hide()
        }
    }

    QsMenuOpener {
        id: opener
        menu: trayMenu.menu
    }

    // Overlay covers entire screen, catches clicks outside menu to close it
    // Only active when menu is visible to avoid unnecessary event capturing
    Rectangle {
        id: overlay
        x: -trayMenu.x
        y: -trayMenu.y
        width: Screen.width
        height: Screen.height
        color: "transparent"
        visible: trayMenu.visible  // Overlay visible only when menu is visible
        z: -1  // Behind menu

        MouseArea {
            anchors.fill: parent
            enabled: trayMenu.visible  // Only enabled when menu is visible
            acceptedButtons: Qt.AllButtons
            onPressed: {
                trayMenu.hide()  // Close menu on any click outside
            }
        }
    }

    ListView {
        id: listView
        anchors.fill: parent
        anchors.margins: 6
        spacing: 2
        interactive: false
        enabled: trayMenu.visible  // Enable interaction only when menu is visible

        model: ScriptModel {
            values: opener.children ? [...opener.children.values] : []
        }

        delegate: Rectangle {
            id: entry
            required property var modelData

            width: listView.width
            height: (modelData?.isSeparator) ? 8 : 28
            color: "transparent"
            radius: 4

            // Separator line if needed
            Rectangle {
                anchors.centerIn: parent
                width: parent.width - 20
                height: 1
                color: Qt.darker(Data.Colors.bgColor, 1.4)
                visible: modelData?.isSeparator ?? false
            }

            // Background highlight on hover for non-separators
            Rectangle {
                anchors.fill: parent
                color: mouseArea.containsMouse ? Data.Colors.highlightBg : "transparent"
                radius: 4
                visible: !(modelData?.isSeparator ?? false)

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 8

                    Text {
                        Layout.fillWidth: true
                        color: (modelData?.enabled ?? true) ? Data.Colors.fgColor : Qt.darker(Data.Colors.fgColor, 1.8)
                        text: modelData?.text ?? ""
                        font.pixelSize: 13
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    Image {
                        Layout.preferredWidth: 16
                        Layout.preferredHeight: 16
                        source: modelData?.icon ?? ""
                        visible: (modelData?.icon ?? "") !== ""
                        fillMode: Image.PreserveAspectFit
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    enabled: (modelData?.enabled ?? true) && !(modelData?.isSeparator ?? false) && trayMenu.visible

                    onClicked: {
                        if (modelData && !modelData.isSeparator) {
                            modelData.triggered()
                            trayMenu.hide()
                        }
                    }
                }
            }
        }
    }

    // Show menu at given point and reparent if needed, with boundary correction
    function show(point, parentItem) {

        if (parentItem) {
            originalParent = parent
            parent = parentItem
            x = point.x
            y = point.y

            // Adjust position to keep menu fully visible on screen
            const globalPos = mapToGlobal(0, 0)
            if (globalPos.x + width > Screen.width) {
                x = point.x - width + 24
            }
            if (globalPos.y + height > Screen.height) {
                y = point.y - height - 5
            }
        } else {
            parent = null
            x = point.x
            y = point.y
        }

        visible = true
    }

    // Hide menu
    function hide() {
        visible = false
    }

    Keys.onEscapePressed: hide()

    // When menu becomes visible, grab focus for keyboard events
    onVisibleChanged: {
        if (visible) {
            forceActiveFocus()
        }
    }

    // Restore original parent on destruction if reparented
    Component.onDestruction: {
        if (originalParent) parent = originalParent
    }
}
