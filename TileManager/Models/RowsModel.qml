import QtQuick 2.12

ListModel {
    id: rowsModel

    property Component _childTemplate: Component {
        RowOfColumnsModel {}
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
