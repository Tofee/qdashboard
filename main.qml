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
                    rowComponent.incubateObject(rootColumn, {width: Qt.binding(function() { return rootColumn.width; })});
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
}
