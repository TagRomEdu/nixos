pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {

    // Weather
    property string weatherLocation: "Dinslaken"
    property var weatherData: ({
        location: "",
        currentTemp: "",
        currentCondition: "",
        details: [],
        forecast: []
    })

    // System Monitor
    property int cpuRefreshInterval: 5000
    property int ramRefreshInterval: 10000
    property string videoPath: "~/Videos/yeet/"

    // Hot Corner bar
    property bool hideRecordButton: false // Hide record icon true/false

    // Audio
    readonly property var defaultAudioSink: Pipewire.defaultAudioSink
    readonly property int volume: defaultAudioSink && defaultAudioSink.audio ? Math.round(defaultAudioSink.audio.volume * 100) : 0
}