// Row of columns, covering the whole width

import QtQuick 2.15
import QtQuick.Layouts 1.12
import QtQml.Models 2.12
import QtQuick.Controls 2.15

SplitView {
    id: rowLayout
    property ObjectModel listObjectColumns: ObjectModel {}

    orientation: Qt.Horizontal

    Repeater {
        model: listObjectColumns
        onItemAdded: {
            // configure the TileColumn to be called when the height changes
            item.containerSplitView = rowLayout;
        }
    }

    Component.onCompleted: {
        for (var i = 0; i < listObjectColumns.count; ++i )
            listObjectColumns.get(i).containerSplitView = rowLayout;

        refreshHeight();
    }

    // hacky refresh, but otherwise the SplitView will impose its height
    // on all the children TileColumn items
    function refreshHeight() {
        var newHeight = 0;
        for (var i = 0; i < listObjectColumns.count; ++i )
            newHeight = Math.max(newHeight, listObjectColumns.get(i).columnHeight);

        rowLayout.height = newHeight;

        debugText.text += "count: " + listObjectColumns.count + "; newHeight = " + newHeight + "\n";
    }
}
