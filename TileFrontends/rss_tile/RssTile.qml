import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12

import "../../TileManager"

TileContentBase {
    id: rootTile

    height: Math.max(200, thefeed.height);

    property string url
    property int refresh_seconds: 600
    property int refresh: 1000 * 600
    property date lastReadItemDate: new Date(0)

    onUrlChanged: jsonModel.refresh();
        
    function stripHtml (str, maxlen) {
        if(!str) return "";
        var regex = /<\/?[^>]+(>|$)/gi;
        str = str.replace(regex, "");
        str = str.replace(/\n/gi, " ");
        str = str.replace(/#[0-9]+;/gi, "");
        return str.substring(0, maxlen);
    }
    function stripImages (str) {
        if(!str) return "";
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
                    var rootObj = JSON.parse(xhr.responseText);
                    var unsortedArray = new Array;

                    if(rootObj.rss) {
                        // RSS feed
                        for (var i_item in rootObj.rss.channel.item) {
                            var rssItem = rootObj.rss.channel.item[i_item];
                            unsortedArray.push({
                                                 "title": rssItem.title,
                                                 "description": (rssItem.description || ""),
                                                 "pubDate": rssItem.pubDate,
                                                 "link": rssItem.link
                                             });
                        }
                        rootTile.setupTitle(rootObj.rss.channel.title);
                    }
                    else if(rootObj.feed){
                        // Atom feed
                        for (var i_entry in rootObj.feed.entry) {
                            var atomEntry = rootObj.feed.entry[i_entry];
                            unsortedArray.push({
                                                 "title": atomEntry.title,
                                                 "description": (atomEntry.content['#text'] || ""),
                                                 "pubDate": (atomEntry.published || ""),
                                                 "link": atomEntry.link['@href']
                                             });
                        }
                        rootTile.setupTitle(rootObj.feed.title);
                    }

                    // sort the array by pubDate
                    unsortedArray.sort(function(a,b) {
                        var dateA = new Date(a.pubDate);
                        var dateB = new Date(b.pubDate);
                        return (dateA<dateB) ? 1 : -1;
                    });

                    // now fill the model
                    jsonModel.clear();
                    for (var i in unsortedArray) {
                        jsonModel.append(unsortedArray[i]);
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
                    font.weight: (!lastReadItemDate || new Date(pubDate) > lastReadItemDate) ? Font.Bold : Font.Light
                    font.pixelSize: 11
                    text: title
                    elide: Text.ElideRight
                }
                Text {
                    visible: Layout.preferredWidth>0
                    Layout.preferredWidth: parent.width - layout.spacing*2 - titleText.implicitWidth - dateText.implicitWidth
                    font.pixelSize: 11
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
                cursorShape: Qt.PointingHandCursor
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

        ScrollBar.vertical: ScrollBar { }
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
        MenuItem {
            text: "Mark all as read"
            onTriggered: {
                lastReadItemDate = new Date();
                saveToModel();
            }
        }
    }

    optionsDialog: Dialog {
        id: dialog
        title: "Options"
        modal: true
        anchors.centerIn: Overlay.overlay
        standardButtons: Dialog.Ok | Dialog.Cancel

        contentWidth: 300

        contentItem: GridLayout {
            columns: 2

            Label {
                text: "RSS/Atom URL: "
                font.bold: true
                font.pixelSize: 12
            }
            TextInput {
                id: optionRssUrl
                text: rootTile.url
                selectByMouse: true
                font.pixelSize: 12

                Layout.fillWidth: true
            }
        }

        onAboutToShow: optionRssUrl.text = rootTile.url
        onAccepted: {
            rootTile.url = urlTextField.text;
            saveToModel();
        }
    }

    function saveToModel() {
        commitContent({
            "feed": rootTile.url,
            "lastReadItemDate": lastReadItemDate,
            "refresh": rootTile.refresh_seconds
        });
    }
    function initFromModel(tileModelContent) {
        rootTile.url = tileModelContent.feed;
        rootTile.lastReadItemDate = tileModelContent.lastReadItemDate || new Date(0);
        rootTile.refresh_seconds = tileModelContent.refresh;
    }
}





