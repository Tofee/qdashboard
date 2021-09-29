import QtQuick 2.0

FocusScope {
    id: rootTile

    height: 100;
    property string tileTitle;
    onTileTitleChanged: setupTitle(tileTitle);

    signal setupTitle(string newTitle);
    signal commitContent(var newContent);
}
