import QtQuick 2.12

ListModel {
    id: rowsModel

    signal commitTileChange(int tileIndex, int colIndex, int rowIndex, var tileContent);

    property Component _childTemplate: Component {
        RowOfColumnsModel {
            onCommitTileChange: {
                for (var i = 0; i < rowsModel.count; ++i) {
                    var row = rowsModel.get(i).content;
                    if(row === this) {
                        rowsModel.commitTileChange(tileIndex, colIndex, i, tileContent);
                        break;
                    }
                }
            }
        }
    }

    function addRow()
    {
        var newRow = _childTemplate.createObject(rowsModel);
        rowsModel.append({"content": newRow});

        newRow.addColumn();
    }

    function serializeSession() {
        // get content for each row
        var rowArray = new Array;
        for (var i = 0; i < rowsModel.count; ++i) {
            var row = rowsModel.get(i).content;
            rowArray.push(row.serializeSession());
        }

        return {
            "rows": rowArray
        };
    }
    function deserializeSession(sessionObject) {
        for(var i = 0; i < sessionObject.rows.length; ++i) {
            var newRow = _childTemplate.createObject(rowsModel);
            newRow.deserializeSession(sessionObject.rows[i]);

            rowsModel.append({"content": newRow});
        }
    }
}
