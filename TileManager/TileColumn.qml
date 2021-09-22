import QtQuick 2.15
import QtQml.Models 2.12
import QtQuick.Controls 2.15

Item {
    id: colWrapper
    height: col.height
    SplitView.minimumWidth: 50

    property ObjectModel listTiles: ObjectModel {}

    property alias columnHeight: col.height
    signal addColumn()

    Component {
        id: tileComponent
        Tile {
            Component.onDestruction: {
                for(var i=0; i<listTiles.count; ++i) {
                    if(listTiles.get(i) === this) {
                        listTiles.remove(i);
                        break;
                    }
                }

                if(listTiles.count === 0) {
                    colWrapper.destroy();
                }
            }
        }
    }

    Column {
        id: col
        width: parent.width
        Repeater {
            model: listTiles
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: contextMenu.popup()

        Menu {
            id: contextMenu
            MenuItem {
                text: "New tile"
                onTriggered: {
                    addTile();
                }
            }
            MenuItem {
                text: "New column"
                onTriggered: {
                    addColumn();
                }
            }
        }
    }

    DropArea {
        anchors.fill: parent
        onDropped: {
            listTiles.append(drag.source.parentTile);
        }
    }

    function addTile() {
        var newTile = tileComponent.createObject(listTiles);
        listTiles.append(newTile);
    }

    function serializeSession() {
        // get content for each line in tile column
        var tileArray = new Array;
        for (var i = 0; i < listTiles.count; ++i) {
            var tile = listTiles.get(i).serializeSession();
            tileArray.push(tile);
        }

        return {
            "width": colWrapper.width,
            "tiles": tileArray
        };
    }

    function deserializeSession(sessionObject) {
        for(var i = 0; i < sessionObject.tiles.length; ++i) {
            var newTile = tileComponent.createObject(listTiles, { "contentItemSource": "" }); // skip the chooser
            newTile.deserializeSession(sessionObject.tiles[i]);

            listTiles.append(newTile);
        }

        colWrapper.implicitWidth = sessionObject.width;
    }
}

