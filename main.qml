import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.12
import QtQml.Models 2.12
import QtQuick.Controls 2.12

import "TileManager"
import "TileManager/Models"
import "TileFrontends/text_tile"
import "TileFrontends/rss_tile"

ApplicationWindow {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("QDashboard")

    property string serverBaseURI: "/qdasboard/api" // overriden by main.cpp
    property string openweatherApiKey: ""

    Component.onCompleted: root.readFromServer();

    Image {
        anchors.fill: parent
        source: "qrc:///TileManager/images/white-waves.png"
        fillMode: Image.Tile
    }

    TabsModel {
        id: tabsModel
    }

    header: TabBar {
        id: tabBar

        Repeater {
            model: tabsModel
            TabButton {
                id: tabButton
                text: model.title
                width: Math.max(implicitWidth, tabTitleInput.implicitWidth)
                height: tabTitleInput.implicitHeight

                Component.onCompleted: tabBar.contentHeight = height

                property int _index: model.index

                onDoubleClicked: {
                    tabButton.display = AbstractButton.IconOnly;
                    tabTitleInput.visible = true;
                    tabTitleInput.focus = true;
                    tabTitleInput.selectAll()
                }
                TextInput {
                    id: tabTitleInput
                    anchors.fill: parent
                    visible: false
                    text: parent.text
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignCenter
                    onEditingFinished: {
                        tabsModel.get(tabButton._index).title = tabTitleInput.text
                        tabTitleInput.visible = false;
                        tabButton.display = AbstractButton.TextOnly
                    }
                }
            }
        }

    }
    MouseArea {
        anchors.fill: header
        acceptedButtons: Qt.RightButton
        onClicked: contextMenu.popup()

        Menu {
            id: contextMenu
            MenuItem {
                text: "Add tab"
                onTriggered: {
                    tabsModel.addTab();
                }
            }
            MenuItem {
                text: "Save"
                onTriggered: {
                    root.save();
                }
            }
        }
    }
    SwipeView {
        anchors.top: tabBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        interactive: false
        currentIndex: tabBar.currentIndex

        Repeater {
            model: tabsModel
            Loader {
                active: SwipeView.isCurrentItem || SwipeView.isNextItem || SwipeView.isPreviousItem
                sourceComponent: TabPage {
                    rowsModel: content
                }
            }
        }
    }

    function serializeSession() {
        // get Json content for the main model
        var serializedSessionObj = tabsModel.serializeSession();

        // add a timestamp
        serializedSessionObj.timestamp = Date.now();

        return serializedSessionObj;
    }

    function deserializeSession(sessionObject) {
        tabsModel.deserializeSession(sessionObject);
    }

    function save() {
        // retrieve whole content
        var content = serializeSession();
        var contentJsonStr = JSON.stringify(content);
        console.log("Content JSON: " + contentJsonStr);

        // call server to save content
        var xhr = new XMLHttpRequest;
        var serviceUrl = serverBaseURI + "/session/save";
        xhr.open("POST", serviceUrl);
        xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        xhr.send(contentJsonStr);
    }

    function readFromServer() {
        var xhr = new XMLHttpRequest;
        var serviceUrl = serverBaseURI + "/session/read";
        xhr.open("GET", serviceUrl);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                //console.log("response: "+xhr.responseText);
                var rootObj = JSON.parse(xhr.responseText);

                if(rootObj) deserializeSession(rootObj);
            }
        }
        xhr.send();
    }
}
