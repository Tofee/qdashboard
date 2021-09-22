import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../TileManager"

FocusScope {
    id: rootItem

    height: textEdit.implicitHeight

    onActiveFocusChanged: {
        var currentText = textEdit.text;
        textEdit.textFormat = rootItem.activeFocus ? TextEdit.PlainText : TextEdit.MarkdownText;
        textEdit.text = "";
        textEdit.text = currentText;
    }

    Rectangle {
        visible: rootItem.activeFocus
        anchors.fill:  parent
        color: "lightBlue"
    }

    TextEdit {
        id: textEdit
        width: parent.width

        font.pointSize: 10
        textFormat: rootItem.activeFocus ? TextEdit.PlainText : TextEdit.MarkdownText
    }

    function serializeSession() {
        // get content for the tile
        return {
            "text": textEdit.text
        };
    }
    function deserializeSession(sessionObject) {
        textEdit.text = sessionObject.text;
    }
}





