import QtQuick 2.12
import QtQuick.Controls 2.12

import "Models"

Item {
    id: rootItem
    height: dragRect.height;
    width: parent ? parent.width : 80;

    property TileModel tileModel

    signal close();

    property alias tileTitle: tileTitleText.text
    property alias backgroundColor: dragRect.color

    // draw a frame:
    // _______________
    // |    title   X|
    // - - - - - - - -
    // |             |
    // |   WIDGET    |
    // |             |
    // ---------------

    // background and border
    Rectangle {
        id: dragRect
        color: tileModel.color
        border {
            color: "grey"
            width: 1
        }
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: rootItem.width
        height: titleRect.height + contentItemLoader.height + 2*border.width

        // drag and drop
        property Item parentTile: rootItem;

        // title + its background
        Rectangle {
            id: titleRect
            color: "#eaf0fa"
            height: tileTitleText.implicitHeight*1.1
            anchors
            {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            anchors.margins: parent.border.width

            Text {
                id: tileTitleText
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: tileModel.title
                font.pixelSize: 12
                font.bold: true
                color: "darkblue"
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                drag.target: dragRect

                drag.onActiveChanged: {
                    dragRect.Drag.drop();
                }
            }

            Button {
                padding: 0
                icon.source: "qrc:///TileManager/images/close.svg"
                icon.color: "transparent"
                icon.height: titleRect.height
                icon.width: titleRect.height
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: icon.width
                onClicked: rootItem.close();
            }
        }

        Loader {
            id: contentItemLoader
            anchors
            {
                top: titleRect.bottom
                left: parent.left
                right: parent.right
            }
            anchors.margins: parent.border.width
            source: tileModel.source
            onSourceChanged: tileModel.source = source

            onLoaded: {
                if(item && item.initFromModel && !!tileModel.contentModel) {
                    item.initFromModel(tileModel.contentModel);
                }
            }
        }
        Connections {
            target: contentItemLoader.item
            function onSetupTitle(newTitle) {
                rootItem.tileTitle = newTitle;
                tileModel.title = newTitle;
            }
            function onCommitContent(newContent) {
                tileModel.contentModel = newContent;
            }
        }

        states: [
            State {
                when: dragRect.Drag.active
                AnchorChanges {
                    target: dragRect
                    anchors.horizontalCenter: undefined
                    anchors.verticalCenter: undefined
                }
            }
        ]

        Drag.active: mouseArea.drag.active
        Drag.hotSpot.x: dragRect.width / 2
        Drag.hotSpot.y: dragRect.height / 2
    }
}
