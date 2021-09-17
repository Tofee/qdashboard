import QtQuick 2.15
import QtQuick.Controls 2.12

Column {
    id: rootTileChooser
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
}
