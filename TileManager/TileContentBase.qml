import QtQuick 2.7
import QtQuick.Controls 2.12

FocusScope {
    id: rootTile

    height: 100;
    property string tileTitle;
    onTileTitleChanged: setupTitle(tileTitle);

    property Dialog optionsDialog;

    signal setupTitle(string newTitle);
    signal commitContent(var newContent);
}
