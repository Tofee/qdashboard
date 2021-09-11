import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("My Dashboard")

    property var tileTree: {
        "kind": "VBox",
        "content": [
           { "kind": "Tile" },
           { "kind": "HBox",
             "content" : [
                 { "kind": "Tile" },
                 { "kind": "Tile" },
                 { "kind": "Tile" } ]
           } ]
    }

    Component {
        id: compVBox
        Column {
            Repeater {
                model: modelContent
                delegate: Loader {
                    property var modelContent: modelData.content;
                    sourceComponent: {
                        if (modelData.kind === "Tile") return compTile;
                        else if (modelData.kind === "VBox") return compVBox;
                        else if (modelData.kind === "HBox") return compHBox;
                    }
                }
            }
        }
    }

    Component {
        id: compHBox
        Row {
            Repeater {
                model: modelContent
                delegate: Loader {
                    property var modelContent: modelData.content;
                    sourceComponent: {
                        if (modelData.kind === "Tile") return compTile;
                        else if (modelData.kind === "VBox") return compVBox;
                        else if (modelData.kind === "HBox") return compHBox;
                    }
                }
            }
        }
    }

    Component {
        id: compTile
        Tile {
            width: 64
            height: 64
        }
    }

    Column {
        Repeater {
            model: tileTree.content
            delegate: Loader {
                property var modelContent: modelData.content;
                sourceComponent: {
                    if (modelData.kind === "Tile") return compTile;
                    else if (modelData.kind === "VBox") return compVBox;
                    else if (modelData.kind === "HBox") return compHBox;
                }
            }
        }
    }
}
