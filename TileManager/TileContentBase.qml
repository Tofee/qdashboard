import QtQuick 2.0

FocusScope {
    id: rootTile

    height: 100;

    property var loaderModelContent: tileModelContent

    signal setupTitle(string newTitle);

    Component.onCompleted: {
        if(rootTile.deserializeSession) rootTile.deserializeSession(rootTile.loaderModelContent)
    }
}
