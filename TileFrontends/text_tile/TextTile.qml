import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../TileManager"

TileContentBase {
    id: rootItem

    height: textEdit.paintedHeight
    tileTitle: "Notepad"

    property alias text: textEdit.text
    property color backgroundColor: "transparent"

    onActiveFocusChanged: {
        var currentText = rootItem.text;
        textEdit.textFormat = rootItem.activeFocus ? TextEdit.PlainText : TextEdit.MarkdownText;
        rootItem.text = "";
        rootItem.text = currentText;
    }

    Rectangle {
        anchors.fill:  parent
        color: rootItem.activeFocus ? "lightBlue" : rootItem.backgroundColor
        opacity: 0.6
    }

    TextEdit {
        id: textEdit
        width: parent.width

        text: ""
        font.pointSize: 10
        textFormat: rootItem.activeFocus ? TextEdit.PlainText : TextEdit.MarkdownText
        wrapMode: Text.WordWrap

        onEditingFinished: {
            saveToModel()
        }
    }

    optionsDialog: Dialog {
        id: dialog
        title: "Options"
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel

        contentWidth: 270 // bof...

        contentItem: PaletteChooser {
        }

        onAccepted: {
            rootItem.backgroundColor = contentItem.selected_color;
            saveToModel();
        }
    }

    function saveToModel() {
        commitContent({
            "text": rootItem.text,
            "backgroundColor": String(rootItem.backgroundColor)
        });
    }
    function initFromModel(tileModelContent) {
        rootItem.text = tileModelContent.text;
        rootItem.backgroundColor = tileModelContent.backgroundColor
    }
}





