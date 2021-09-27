import QtQuick 2.12

QtObject {
    property string source: "qrc:///TileManager/TileChooser.qml" // default source is a chooser
    property string title: "Choose tile type"
    property color color: "transparent"

    property var contentModel

    function serializeSession() {
        return {
            "source": source,
            "title": title,
            "content": contentModel
        };
    }
    function deserializeSession(sessionObject) {
        source = sessionObject.source;
        title = sessionObject.title || "";

        contentModel = sessionObject.content;
    }
}
