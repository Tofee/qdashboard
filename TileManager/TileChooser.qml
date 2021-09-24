import QtQuick 2.15
import QtQuick.Controls 2.12

TileContentBase {
    id: rootTileChooser

    height: choicesColumn.height

    Column {
        id: choicesColumn
        width: parent.width

        Button {
            width: parent.width
            text: "Rss tile"
            onClicked: {
                // change the Loader's source
                rootTileChooser.parent.source = "qrc:///TileFrontends/rss_tile/RssTile.qml";
            }
        }
        Button {
            width: parent.width
            text: "Text tile"
            onClicked: {
                // change the Loader's source
                rootTileChooser.parent.source = "qrc:///TileFrontends/text_tile/TextTile.qml";
            }
        }
        Button {
            width: parent.width
            text: "Weather tile"
            onClicked: {
                // change the Loader's source
                rootTileChooser.parent.source = "qrc:///TileFrontends/weather_tile/WeatherTile.qml";
            }
        }
    }
}
