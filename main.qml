import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.12
import QtQml.Models 2.12
import QtQuick.Controls 2.12

import "TileManager"
import "TileFrontends/text_tile"
import "TileFrontends/rss_tile"

Window {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("QDashboard")

    property string serverBaseURI: "/qdasboard/api" // overriden by main.cpp
    property string openweatherApiKey: ""

    Component.onCompleted: root.readFromServer();

    Component {
        id: rowComponent
        RowOfColumns {}
    }

    MouseArea {
        z: 0
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: contextMenu.popup()

        Menu {
            id: contextMenu
            MenuItem {
                text: "New row"
                onTriggered: {
                    var newRow = rowComponent.createObject(rootColumn, {width: Qt.binding(function() { return rootColumn.width; })});
                    newRow.addColumn();
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

    Column {
        z: 1
        id: rootColumn
        width: parent.width
        spacing: 5
    }

    function serializeSession() {
        // get Json content for each line in rootColumn
        var rowArray = new Array;
        for (var i = 0; i < rootColumn.children.length; ++i) {
            rowArray.push(rootColumn.children[i].serializeSession());
        }

        return {
            "timestamp": Date.now(),
            "rows": rowArray
        };
    }

    function deserializeSession(sessionObject) {
        for(var i = 0; i < sessionObject.rows.length; ++i) {
            var newRow = rowComponent.createObject(rootColumn, {width: Qt.binding(function() { return rootColumn.width; })});
            newRow.deserializeSession(sessionObject.rows[i]);
        }
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
                console.log("response: "+xhr.responseText);
                var rootObj = JSON.parse(xhr.responseText);

                if(rootObj) deserializeSession(rootObj);
            }
        }
        xhr.send();
    }
}
