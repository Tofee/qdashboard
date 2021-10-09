import QtQuick 2.15
import QtQml.Models 2.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12

import "Models"

Item {
    id: colWrapper
    height: col.height

    property TileColumnModel tileColumnModel

    signal removeColumn();
    signal addColumn()

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: contextMenu.popup()

        Menu {
            id: contextMenu
            MenuItem {
                text: "New tile"
                onTriggered: {
                    tileColumnModel.addTile();
                }
            }
            MenuItem {
                text: "New column"
                onTriggered: {
                    colWrapper.addColumn();
                }
            }
        }
    }

    Column {
        id: col
        width: parent.width
        Repeater {
            model: tileColumnModel
            delegate: Tile {
                id: tileDelegate
                tileModel: content

                onClose: {
                    if(tileColumnModel.count === 1) {
                        colWrapper.removeColumn();
                    }
                    else {
                        tileColumnModel.remove(index);
                    }
                }
            }
        }
    }

    DropArea {
        anchors.fill: parent
        onDropped: {
            var serializedTile = drag.source.parentTile.tileModel.serializeSession();
            tileColumnModel.addTile(serializedTile);
            drag.source.parentTile.close();
        }
    }
}

