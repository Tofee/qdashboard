import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12

import "../../TileManager"

TileContentBase {
    id: rootTile

    height: 200;

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
        
    function stripString (str) {
        var regex = /(<img.*?>)/gi;
        str = str.replace(regex, "");
        regex = /&#228;/gi;
        str = str.replace(regex, "ä");
        regex = /&#246;/gi;
        str = str.replace(regex, "ö");
        regex = /&#252;/gi;
        str = str.replace(regex, "ü");
        regex = /&#196;/gi;
        str = str.replace(regex, "Ä");
        regex = /&#214;/gi;
        str = str.replace(regex, "Ö");
        regex = /&#220;/gi;
        str = str.replace(regex, "Ü");
        regex = /&#223;/gi;
        str = str.replace(regex, "ß");
        
        return str;
    }
    
    ListModel {
        id: jsonModel
        Component.onCompleted: jsonModel.refresh()

        function refresh () {
            var xhr = new XMLHttpRequest;
            console.log("URL: "+_getServiceURL(url));
            xhr.open("GET", _getServiceURL(url));
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    jsonModel.clear();

                    var rootObj = JSON.parse(xhr.responseText);
                    for (var b in rootObj.rss.channel.item) {
                        jsonModel.append(rootObj.rss.channel.item[b]);
                    }

                    rootTile.setupTitle(rootObj.rss.channel.title);
                }
            }
            xhr.send();
        }

        function _getServiceURL(origUrl) {
            return serverBaseURI+"/rss_tile/content/" + Qt.btoa(origUrl)
        }
    }

    Component {
        id: feedDelegate
        Item {
            height: layout.height;
            width: parent.width-20;

            RowLayout {
                id: layout
                width: parent.width
                height: titleText.implicitHeight

                Text {
                    id: titleText
                    Layout.fillWidth: true
                    Layout.minimumWidth: implicitWidth
                    font.weight: Font.Bold
                    font.pixelSize: 12
                    text: title
                }
                Text {
                    Layout.maximumWidth: parent.width - titleText.implicitWidth - dateText.implicitWidth
                    font.pixelSize: 12
                    font.weight: Font.Light
                    elide: Text.ElideRight
                    text: stripString(description)
                }
                Text {
                    id: dateText
                    Layout.minimumWidth: implicitWidth
                    font.pixelSize: 9;
                    text: {
                        return new Date(pubDate).toLocaleString(Qt.locale(), Locale.ShortFormat)
                    }
                }
            }
            MouseArea{
                id: itemMouseArea
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                anchors.fill: parent
                onClicked: {
                    if (mouse.button == Qt.LeftButton)
                    {
                        Qt.openUrlExternally(link)
                    }
                    else if (mouse.button == Qt.RightButton)
                    {
                        contextMenu.popup()
                    }
                }
            }
        }
    }
    
    ListView {
        id: thefeed
        clip: true
        width: parent.width
        anchors.fill:  parent
        spacing: 2
        model: jsonModel
        delegate: feedDelegate
        snapMode: ListView.SnapToItem
    }
    
    Timer {        
        id: refreshTimer
        interval: refresh
        running: true
        repeat: true
        onTriggered: { jsonModel.refresh() }
    }
    
    Menu {
        id: contextMenu
        MenuItem {
            text: "Reload"
            onTriggered: {
                jsonModel.refresh()
            }
        }    
    }
    
    function serializeSession() {
        // get content for the tile
        return {
            "feed": configuration.url,
            "refresh": configuration.refresh
        };
    }
    function deserializeSession(sessionObject) {
        configuration.url = sessionObject.feed;
        configuration.refresh = sessionObject.refresh;
    }
}





