import QtQuick

/**
 * Manages dynamic loading and unloading of QML components.
 * Provides a centralized way to handle component lifecycle and memory management.
 */
QtObject {
    id: root

    // Stores active loader instances by their component URL
    property var activeLoaders: ({})
    
    /**
     * Loads a QML component dynamically and manages its lifecycle.
     * @param componentUrl - URL of the QML component to load
     * @param parent - Parent item for the loader
     * @param properties - Optional properties to set on the loaded component
     * @returns The loader instance for the component
     */
    function load(componentUrl, parent, properties) {
        if (!activeLoaders[componentUrl]) {
            // Create loader with async loading enabled for better performance
            var loader = Qt.createQmlObject(`
                import QtQuick
                Loader {
                    active: false
                    asynchronous: true
                    visible: false
                }
            `, parent);
            
            loader.source = componentUrl
            loader.active = true
            
            // Apply any provided properties to the loader
            if (properties) {
                for (var prop in properties) {
                    loader[prop] = properties[prop]
                }
            }
            
            activeLoaders[componentUrl] = loader
        }
        return activeLoaders[componentUrl]
    }
    
    /**
     * Unloads a component and cleans up its resources.
     * @param componentUrl - URL of the component to unload
     */
    function unload(componentUrl) {
        if (activeLoaders[componentUrl]) {
            activeLoaders[componentUrl].active = false
            activeLoaders[componentUrl].destroy()
            delete activeLoaders[componentUrl]
        }
    }
    
    /**
     * Checks if a component is currently loaded.
     * @param componentUrl - URL of the component to check
     * @returns True if the component is loaded, false otherwise
     */
    function isLoaded(componentUrl) {
        return !!activeLoaders[componentUrl]
    }
} 