// Row of columns, covering the whole width

import QtQuick 2.15
import QtQuick.Layouts 1.12
import QtQml.Models 2.12
import QtQuick.Controls 2.15

import "Models"

Item {
    property RowsModel rowsModel

    // put mousearea first, so that content's contextual menus may override us
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: contextMenu.popup()

        Menu {
            id: contextMenu
            MenuItem {
                text: "New row"
                onTriggered: {
                    rowsModel.addRow();
                }
            }
        }
    }
    Flickable {
        anchors.fill: parent

        contentWidth: parent.width; contentHeight: rootColumn.height
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: rootColumn
            width: parent.width
            spacing: 5

            Repeater {
                model: rowsModel
                delegate: RowOfColumns {
                    columnsModel: content
                    width: rootColumn.width

                    onRemoveRow: {
                        rowsModel.remove(index);
                    }
                }
            }
        }
    }
}
