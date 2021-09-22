import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12

import "../../TileManager"

Item {
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
        Component.onCompleted: {
            var xhr = new XMLHttpRequest;
            console.log("URL: "+_getServiceURL(url));
            xhr.open("GET", _getServiceURL(url));
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    var rootObj = JSON.parse(xhr.responseText);
                    for (var b in rootObj.rss.channel.item) {
                        jsonModel.append(rootObj.rss.channel.item[b]);
                    }
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
        Rectangle {
            height: layout.height;
            width: thefeed.width;
            color: backColor
            Item     {
                height: layout.height;
                width: thefeed.width;
                Column {
                    id: layout;
                    Row {
                        Text {
                            wrapMode: "WordWrap";
                            font.pixelSize: 12;
                            color: foreColor;
                            font.bold: true;
                            text: title }
                    }
                    Row {
                        Text {
                            width: thefeed.width;
                            wrapMode: "WordWrap";
                            font.pixelSize: 9;
                            color: headerColor;
                            font.bold: false;
                            text: pubDate }
                    }
                    Row {
                        Text {
                            width: thefeed.width;
                            wrapMode: "WordWrap";
                            font.pixelSize: 12;
                            color: foreColor;
                            font.bold: false;
                            text: stripString(description) }
                    }
                    Row {
                        Rectangle {
                            width: thefeed.width;
                            color: foreColor;
                            height: 1;
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
        
    }
    
    Component {
        id: header
        Rectangle {
            width: thefeed.width; height: 19
            color: backColor
            Item {
                width: thefeed.width; height: 19
                Text {
                    horizontalAlignment: Text.AlignRight
                    width: thefeed.width; height: 8
                    font.pixelSize: 9;
                    text: url;
                    color: headerColor
                    
                }
                Rectangle {
                    y: 11
                    width: thefeed.width; height: 8
                    color: headerColor
                }
            }
        }
    }
    
    Component {
        id: footer
        Rectangle {
            width: thefeed.width; height: 8
            color: headerColor
        }
    }    
    ListView {
        id: thefeed
        maximumFlickVelocity: 2500
        clip: true
        width: parent.width-20
        anchors.fill:  parent
        spacing: 2
        model: jsonModel
        delegate: feedDelegate
        header: header
        footer: footer
        snapMode: ListView.SnapToItem
    }
    MouseArea {
        id: itemMouseArea
        acceptedButtons: Qt.RightButton
        anchors.fill: parent
        onClicked: {
            //              right button is clicked
            contextMenu.popup()
        }
    }
    
    Timer {        
        id: refreshTimer
        interval: refresh
        running: true
        repeat: true
        onTriggered: { xmlModel.reload() }
    }    
    
    Menu {
        id: contextMenu
        MenuItem {
            text: "Reload"
            onTriggered: {
                xmlModel.reload()
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





