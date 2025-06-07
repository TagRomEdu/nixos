import QtQuick
import QtQuick.Controls
import QtQuick.Shapes

Shape {
    id: topLeftCorner
    required property var shell
    required property var popup
    required property var barRect
    width: 20
    height: 32
    y: barRect.y
    x: barRect.x + barRect.width - 164
    preferredRendererType: Shape.CurveRenderer

    opacity: 0
    Component.onCompleted: opacity = 1
    Behavior on opacity {
        NumberAnimation {
            duration: 600
            easing.type: Easing.OutCubic
        }
    }

    ShapePath {
        strokeWidth: 0
        fillColor: shell.accentColor
        strokeColor: "transparent"

        // Start at middle height LEFT edge (mirrored from right edge)
        startX: 0
        startY: 5

        // Concave arc from middle left to bottom right corner (mirrored horizontally)
        PathArc {
            x: width
            y: height
            radiusX: 40
            radiusY: 40
            useLargeArc: false
            direction: PathArc.Clockwise  // flipped direction for concavity
        }

        // Line up the right edge
        PathLine { x: width; y: 0 }

        // Line along top edge back to left top corner
        PathLine { x: 0; y: 0 }

        // Close the path back to start
        PathLine { x: 0; y: 5 }
    }
}
