import QtQuick 2.12

ListModel {
    id: rowOfColumnsModel

    signal commitTileChange(int tileIndex, int colIndex, var tileContent);

    property Component _childTemplate: Component {
        TileColumnModel {
            onCommitTileChange: {
                for (var i = 0; i < rowOfColumnsModel.count; ++i) {
                    var column = rowOfColumnsModel.get(i).content;
                    if(column === this) {
                        rowOfColumnsModel.commitTileChange(tileIndex, i, tileContent);
                        break;
                    }
                }
            }
        }
    }

    function addColumn()
    {
        var newColumn = _childTemplate.createObject(rowOfColumnsModel);
        rowOfColumnsModel.append({"content": newColumn});

        // a new column can't be empty
        newColumn.addTile();
    }

    function serializeSession() {
        // get content for each column in the splitview
        var columnArray = new Array;
        for (var i = 0; i < rowOfColumnsModel.count; ++i) {
            var column = rowOfColumnsModel.get(i).content;
            columnArray.push(column.serializeSession());
        }

        return {
            "columns": columnArray
        };
    }
    function deserializeSession(sessionObject) {
        for(var i = 0; i < sessionObject.columns.length; ++i) {
            var newColumn = _childTemplate.createObject(rowOfColumnsModel);
            newColumn.deserializeSession(sessionObject.columns[i]);

            rowOfColumnsModel.append({"content": newColumn});
        }
    }
}
