import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../TileManager"

TileContentBase {
    id: rootItem

    height: textEdit.paintedHeight
    tileTitle: "Notepad"

    property alias text: textEdit.text
    property color backgroundColor: "transparent"

    Rectangle {
        id: backgroundRect
        anchors.fill:  parent
        color: textEdit.activeFocus ? "lightBlue" : rootItem.backgroundColor
        opacity: 0.6
    }

    TextEdit {
        id: spuriousTextEdit
        width: 0
        height: 0
    }
    TextEdit {
        id: textEdit
        width: parent.width

        activeFocusOnPress: false
        selectByMouse: true
        text: ""
        font.pointSize: 10
        textFormat: TextEdit.MarkdownText
        wrapMode: Text.WordWrap

        onActiveFocusChanged: {
            console.log("activeFocus="+activeFocus);
            var currentText = rootItem.text;
            textEdit.textFormat = textEdit.activeFocus ? TextEdit.PlainText : TextEdit.MarkdownText;
            rootItem.text = "";
            rootItem.text = currentText;
        }

        onEditingFinished: {
            saveToModel()
        }
        onLinkActivated: {
            if(!activeFocus) Qt.openUrlExternally(link)
        }
    }
    ToolButton {
        anchors.top: textEdit.top
        anchors.right: textEdit.right
        text: textEdit.activeFocus?"Save":"Edit"
        focusPolicy: Qt.NoFocus
        padding: 0
        background: Rectangle {
            border.color: "gray"
            border.width: 1
            color : textEdit.activeFocus?"orange":"lightblue"
            opacity: 0.6
        }

        onClicked: {
            if(!textEdit.activeFocus) {
                textEdit.forceActiveFocus();
            }
            else {
                forceActiveFocus()
            }
        }
    }

    optionsDialog: Dialog {
        id: dialog
        title: "Options"
        modal: true
        anchors.centerIn: Overlay.overlay
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





