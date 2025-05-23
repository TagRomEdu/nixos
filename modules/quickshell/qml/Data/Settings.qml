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
    readonly property bool weatherLoading: false

    // Audio
    readonly property var defaultAudioSink: Pipewire.defaultAudioSink
    readonly property int volume: defaultAudioSink && defaultAudioSink.audio ? Math.round(defaultAudioSink.audio.volume * 100) : 0
}