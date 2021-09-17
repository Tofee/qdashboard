import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../TileManager"

Item {
    id: rootItem

    height: textEdit.implicitHeight
    
    property var configuration: {
        "url": "https://www.nasa.gov/rss/dyn/breaking_news.rss",
        "refresh": 600,
        "backColor": "white",
        "foreColor": "black",
        "headerColor": "darkgrey",
    }

    property var url: configuration.url
    property int refresh: 1000 * configuration.refresh
    property var backColor: configuration.backColor
    property var foreColor: configuration.foreColor
    property var headerColor: configuration.headerColor
        
    Rectangle {
        visible: textEdit.focus
        anchors.fill:  parent
        color: "lightBlue"
    }

    TextEdit {
        id: textEdit
        width: parent.width
    }
}





