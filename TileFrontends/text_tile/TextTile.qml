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
        color: textEdit.readOnly ? rootItem.backgroundColor : "lightBlue"
        opacity: 0.6
    }

    TextEdit {
        id: textEdit
        width: parent.width

        activeFocusOnPress: true
        selectByMouse: true
        text: ""
        font.pointSize: 10
        textFormat: TextEdit.MarkdownText
        wrapMode: Text.WordWrap
        readOnly: true

        onReadOnlyChanged: {
            // remove markdown links
            var markdownLinksToText = /\[[^\]]+\]\(([^\)]+)\)/gi
            var markdownAsText = textEdit.text.replace(markdownLinksToText, "$1");
            textEdit.clear();
            textEdit.text = markdownAsText;
        }

        onEditingFinished: {
            saveToModel()
        }
        onLinkActivated: {
            if(readOnly) Qt.openUrlExternally(link)
        }
    }
    ToolButton {
        anchors.top: textEdit.top
        anchors.right: textEdit.right
        text: textEdit.readOnly?"Edit":"Save"
        focusPolicy: Qt.NoFocus
        padding: 0
        background: Rectangle {
            border.color: "gray"
            border.width: 1
            color : textEdit.readOnly?"lightblue":"orange"
            opacity: 0.6
        }

        onClicked: {
            textEdit.readOnly = !textEdit.readOnly;
            if(!textEdit.readOnly) {
                textEdit.forceActiveFocus();
            }
            else {
                forceActiveFocus();
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





