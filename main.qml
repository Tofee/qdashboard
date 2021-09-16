import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.12
import QtQml.Models 2.12

import "TileManager"
import "TileFrontends/text_tile"
import "TileFrontends/rss_tile"

Window {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Column {
        width: parent.width
        spacing: 5

        RowOfColumns {
            width: parent.width
            listObjectColumns: ObjectModel {
                TileColumn {
                    listTiles: ObjectModel {
                        TextTile { color: "orange" }
                        RssTile { color: "lightblue" }
                        Tile { color: "blue" }
                    }
                }
                TileColumn {
                    listTiles: ObjectModel {
                        Tile { color: "red" }
                        Tile { color: "green" }
                        Tile { color: "blue" }
                    }
                }
                TileColumn {
                    listTiles: ObjectModel {
                        Tile { color: "yellow" }
                        Tile { color: "grey" }
                        Tile { color: "black" }
                    }
                }
            }
        }
        RowOfColumns {
            width: parent.width
            listObjectColumns: ObjectModel {
                TileColumn {
                    listTiles: ObjectModel {
                        Tile { color: "yellow" }
                        Tile { color: "grey" }
                        Tile { color: "black" }
                    }
                }
                TileColumn {
                    listTiles: ObjectModel {
                        Tile { color: "red" }
                        Tile { color: "green" }
                        Tile { color: "blue" }
                    }
                }
            }
        }

        Text {
            id: debugText
            width: parent.width
            height: 200
            text: "running...\n"
        }
    }
}
