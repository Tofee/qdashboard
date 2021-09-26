import QtQuick 2.0

FocusScope {
    id: rootTile

    height: 100;

    /*
      loaderTileModelContent is exposed by the Loader of the generic Tile, to give access to the
      specific data of the tile. It is directly a JS object.
      Beware, no property binding here !
    */
    property var tileModelContent : loaderTileModelContent

    signal setupTitle(string newTitle);

    Component.onCompleted: if(rootTile.initFromModel && !!tileModelContent) rootTile.initFromModel()
}
