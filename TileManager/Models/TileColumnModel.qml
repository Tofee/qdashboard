import QtQuick 2.12

ListModel {
    id: tileColumnModel

    property real weight: 1.0 // by defautl, each column weights the same. Total weight is always listObjectColumns.count.

    property Component _childTemplate: Component {
        TileModel {}
    }

    function addTile(serializedTile) {
        var newTile = _childTemplate.createObject(tileColumnModel);
        if(!!serializedTile) newTile.deserializeSession(serializedTile);
        tileColumnModel.append({ "content": newTile });
    }

    function serializeSession() {
        // get content for each line in tile column
        var tileArray = new Array;
        for (var i = 0; i < tileColumnModel.count; ++i) {
            var tile = tileColumnModel.get(i).content;
            tileArray.push(tile.serializeSession());
        }

        return {
            "weight": tileColumnModel.weight,
            "tiles": tileArray
        };
    }

    function deserializeSession(sessionObject) {
        for(var i = 0; i < sessionObject.tiles.length; ++i) {
            addTile(sessionObject.tiles[i]);
        }

        tileColumnModel.weight = sessionObject.weight || 1.0;
    }
}
