import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12

import "../../TileManager"

TileContentBase {
    id: rootTile

    height: Math.max(200, thefeed.height);

    property string url
    property int refresh_seconds: 600;
    property int refresh: 1000 * 600

    onUrlChanged: jsonModel.refresh();
        
    function stripHtml (str, maxlen) {
        var regex = /<\/?[^>]+(>|$)/gi;
        str = str.replace(regex, "");
        str = str.replace(/\n/gi, " ");
        str = str.replace(/#[0-9]+;/gi, "");
        return str.substring(0, maxlen);
    }
    function stripImages (str) {
        var regex = /(<img.*?>)/gi;
        str = str.replace(regex, "");
        str = str.replace(/#[0-9]+;/gi, "");
        return str;
    }
    
    ListModel {
        id: jsonModel
        Component.onCompleted: jsonModel.refresh()

        function refresh () {
            if(url.length === 0) return;

            var xhr = new XMLHttpRequest;
            //console.log("URL: "+_getServiceURL(url));
            xhr.open("GET", _getServiceURL(url));
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    jsonModel.clear();

                    var rootObj = JSON.parse(xhr.responseText);

                    if(rootObj.rss) {
                        // RSS feed
                        for (var i_item in rootObj.rss.channel.item) {
                            jsonModel.append(rootObj.rss.channel.item[i_item]);
                        }
                        rootTile.setupTitle(rootObj.rss.channel.title);
                    }
                    else if(rootObj.feed){
                        // Atom feed
                        for (var i_entry in rootObj.feed.entry) {
                            var atomEntry = rootObj.feed.entry[i_entry];
                            jsonModel.append({
                                                 "title": atomEntry.title,
                                                 "description": atomEntry.content['#text'],
                                                 "pubDate": atomEntry.published
                                             });
                        }
                        rootTile.setupTitle(rootObj.feed.title);
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
        Item {
            height: layout.height;
            width: thefeed.width-20;

            RowLayout {
                id: layout
                width: parent.width
                height: titleText.implicitHeight

                Text {
                    id: titleText
                    Layout.fillWidth: true
                    font.weight: Font.Bold
                    font.pixelSize: 12
                    text: title
                    elide: Text.ElideRight
                }
                Text {
                    visible: Layout.preferredWidth>0
                    Layout.preferredWidth: parent.width - layout.spacing*2 - titleText.implicitWidth - dateText.implicitWidth
                    font.pixelSize: 12
                    font.weight: Font.Light
                    elide: Text.ElideRight
                    text: stripHtml(description, 100)
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

            ToolTip.delay: 500
            ToolTip.visible: itemMouseArea.containsMouse
            ToolTip.text: stripImages(description)

            MouseArea{
                id: itemMouseArea
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                anchors.fill: parent
                hoverEnabled: true
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
        header: TextField {
            width: parent.width

            id: urlTextField
            text: rootTile.url
            onEditingFinished: {
                rootTile.url = urlTextField.text;
            }
            font.pixelSize: 12
        }

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
            "feed": rootTile.url,
            "refresh": rootTile.refresh_seconds
        };
    }
    function deserializeSession(sessionObject) {
        rootTile.url = sessionObject.feed;
        rootTile.refresh_seconds = sessionObject.refresh;
    }
}





