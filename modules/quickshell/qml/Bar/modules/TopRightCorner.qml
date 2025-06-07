import QtQuick
import QtQuick.Controls
import QtQuick.Shapes

Shape {
    id: topRightCorner
    required property var shell
    required property var popup
    required property var barRect
    width: 20
    height: 32
    y: barRect.y
    x: barRect.x + barRect.width + 42
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

        // Start at middle height right edge (vertically flipped)
        startX: width
        startY: 5

        // Concave arc from middle right to bottom left corner (vertically flipped)
        PathArc {
            x: 0
            y: height
            radiusX: 40
            radiusY: 40
            useLargeArc: false
            direction: PathArc.Counterclockwise  // changed to keep concave shape
        }

        // Line up the left edge
        PathLine { x: 0; y: 0 }

        // Line along top edge back to right top corner
        PathLine { x: 20; y: 0 }

        // Close the path back to start
        PathLine { x: width; y: height / 2 }
    }
}