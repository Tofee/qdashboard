// Row of columns, covering the whole width

import QtQuick 2.15
import QtQuick.Layouts 1.12
import QtQml.Models 2.12
import QtQuick.Controls 2.15

SplitView {
    id: rowLayout
    property ObjectModel listObjectColumns: ObjectModel {}

    orientation: Qt.Horizontal

    Component {
        id: columnComponent
        TileColumn {
            onColumnHeightChanged: rowLayout.refreshHeight();
            onAddColumn: rowLayout.addColumn();

            Component.onDestruction: {
                for(var i=0; i<listObjectColumns.count; ++i) {
                    if(listObjectColumns.get(i) === this) {
                        listObjectColumns.remove(i);
                        break;
                    }
                }

                if(listObjectColumns.count === 0) {
                    rowLayout.destroy();
                }
            }
        }
    }

    Repeater {
        model: listObjectColumns
    }

    function addColumn()
    {
        var newColumn = columnComponent.createObject(listObjectColumns);
        listObjectColumns.append(newColumn);

        newColumn.addTile();
    }

    function serializeSession() {
        // get content for each column in the splitview
        var columnArray = new Array;
        for (var i = 0; i < listObjectColumns.count; ++i) {
            var column = listObjectColumns.get(i).serializeSession();
            columnArray.push(column);
        }

        return {
            "columns": columnArray
        };
    }
    function deserializeSession(sessionObject) {
        for(var i = 0; i < sessionObject.columns.length; ++i) {
            var newColumn = columnComponent.createObject(listObjectColumns);
            newColumn.deserializeSession(sessionObject.columns[i]);

            listObjectColumns.append(newColumn);
        }
    }

    Component.onCompleted: {
        refreshHeight();
    }

    // hacky refresh, but otherwise the SplitView will impose its height
    // on all the children TileColumn items
    function refreshHeight() {
        var newHeight = 0;
        for (var i = 0; i < listObjectColumns.count; ++i )
            newHeight = Math.max(newHeight, listObjectColumns.get(i).columnHeight);

        rowLayout.height = newHeight;
    }
}
