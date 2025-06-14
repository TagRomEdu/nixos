pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // Configuration paths - relative to QML directory
    readonly property url configDir: "../../.config/quickshell"
    readonly property url cacheDir: "../../.cache/quickshell"

    // Configuration file view
    FileView {
        id: configFile
        path: root.configDir + "/config.json"
        
        onAdapterUpdated: writeAdapter()
        onFileChanged: reload()

        JsonAdapter {
            id: configData
            property bool isDarkTheme: true
        }
    }

    // Expose the theme setting
    property alias isDarkTheme: configData.isDarkTheme

    Component.onCompleted: {
        // Ensure config directory exists
        const process = Qt.createQmlObject('
            import Quickshell.Io;
            Process {
                command: ["mkdir", "-p", "' + configDir + '"]
                running: true
            }
        ', root);
    }
} 