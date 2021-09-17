import QtQuick 2.15
import QtQml.Models 2.12
import QtQuick.Controls 2.15

Item {
    id: colWrapper
    height: col.height
    SplitView.preferredWidth: 150

    property ObjectModel listTiles: ObjectModel { Tile {} }

    // todo: find a nicer way to update the SplitView's height
    property alias columnHeight: col.height
    property SplitView containerSplitView
    onColumnHeightChanged: if(containerSplitView) containerSplitView.refreshHeight();

    Component {
        id: tileComponent
        Tile {}
    }

    Column {
        id: col
        width: parent.width
        Repeater {
            model: listTiles
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: contextMenu.popup()

        Menu {
            id: contextMenu
            MenuItem {
                text: "New tile"
                onTriggered: {
                    listTiles.append(tileComponent.createObject(listTiles));
                }
            }
            MenuItem {
                text: "New column"
                onTriggered: {
                    if(containerSplitView) containerSplitView.addColumn();
                }
            }
        }
    }

    DropArea {
        anchors.fill: parent
        onDropped: {
            listTiles.append(drag.source.parentTile);
        }
    }
}

