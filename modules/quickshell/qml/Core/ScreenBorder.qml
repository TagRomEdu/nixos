import QtQuick
import QtQuick.Shapes
import Qt5Compat.GraphicalEffects
import "root:/Data/" as Data

Item {
    id: border
    width: Screen.width
    height: Screen.height

    // Main container for visual elements
    Item {
        id: visualContainer
        anchors.fill: parent
        
        // Background shape
        Shape {
            id: borderShape
            anchors.fill: parent
            layer.enabled: true
            layer.samples: 8
            smooth: true
            antialiasing: true

            ShapePath {
                fillColor: Data.Colors.bgColor
                strokeWidth: 0
                fillRule: ShapePath.OddEvenFill

                PathMove { x: 0; y: 0 }
                PathLine { x: width; y: 0 }
                PathLine { x: width; y: height }
                PathLine { x: 0; y: height }
                PathLine { x: 0; y: 0 }

                PathMove {
                    x: Data.Settings.borderWidth
                    y: Data.Settings.borderWidth + Data.Settings.cornerRadius
                }

                PathArc {
                    x: Data.Settings.borderWidth + Data.Settings.cornerRadius
                    y: Data.Settings.borderWidth
                    radiusX: Data.Settings.cornerRadius
                    radiusY: Data.Settings.cornerRadius
                    direction: PathArc.Clockwise
                }

                PathLine {
                    x: width - Data.Settings.borderWidth - Data.Settings.cornerRadius
                    y: Data.Settings.borderWidth
                }

                PathArc {
                    x: width - Data.Settings.borderWidth
                    y: Data.Settings.borderWidth + Data.Settings.cornerRadius
                    radiusX: Data.Settings.cornerRadius
                    radiusY: Data.Settings.cornerRadius
                    direction: PathArc.Clockwise
                }

                PathLine {
                    x: width - Data.Settings.borderWidth
                    y: height - Data.Settings.borderWidth - Data.Settings.cornerRadius
                }

                PathArc {
                    x: width - Data.Settings.borderWidth - Data.Settings.cornerRadius
                    y: height - Data.Settings.borderWidth
                    radiusX: Data.Settings.cornerRadius
                    radiusY: Data.Settings.cornerRadius
                    direction: PathArc.Clockwise
                }

                PathLine {
                    x: Data.Settings.borderWidth + Data.Settings.cornerRadius
                    y: height - Data.Settings.borderWidth
                }

                PathArc {
                    x: Data.Settings.borderWidth
                    y: height - Data.Settings.borderWidth - Data.Settings.cornerRadius
                    radiusX: Data.Settings.cornerRadius
                    radiusY: Data.Settings.cornerRadius
                    direction: PathArc.Clockwise
                }

                PathLine {
                    x: Data.Settings.borderWidth
                    y: Data.Settings.borderWidth + Data.Settings.cornerRadius
                }
            }
        }

        // Inner content area
        Rectangle {
            id: innerArea
            anchors {
                fill: parent
                margins: Data.Settings.borderWidth
            }
            color: "transparent"
            radius: Data.Settings.cornerRadius

            // Shadow effect
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: -4
                verticalOffset: -4
                radius: 12
                samples: 16
                color: Data.Colors.withOpacity(Data.Colors.base00, 0.25)
                cached: true
            }
        }
    }

    // Force immediate update when theme changes
    Connections {
        target: Data.Colors
        function onIsDarkThemeChanged() {
            borderShape.visible = false
            borderShape.visible = true
        }
    }
}
