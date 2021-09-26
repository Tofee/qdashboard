import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../TileManager"

TileContentBase {
    id: rootItem

    height: textEdit.paintedHeight

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
        wrapMode: Text.WordWrap

        onTextChanged: saveToModel()
    }

    function saveToModel() {
        tileModelContent = {
            "text": textEdit.text
        };
    }
    function initFromModel() {
        textEdit.text = tileModelContent.text;
    }
}





