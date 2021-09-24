import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: rootItem
    height: dragRect.height;
    width: parent ? parent.width : 80;

    property alias tileTitle: tileTitleText.text
    property alias backgroundColor: dragRect.color

    default property alias contentItemSource: contentItemLoader.source

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
        color: "white"
        border {
            color: "grey"
            width: 1
        }
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: rootItem.width
        height: titleRect.height + contentItemLoader.height

        // drag and drop
        property Item parentTile: rootItem;

        // title + its background
        Rectangle {
            id: titleRect
            color: "lightblue"
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
                anchors.centerIn: parent
                text: "Title"
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                drag.target: dragRect

                drag.onActiveChanged: {
                    if (mouseArea.drag.active) {
                     //   rootItem.dragItemIndex = rootItem.index;
                    }
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
                onClicked: rootItem.destroy();
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
            source: "qrc:///TileManager/TileChooser.qml" // default source is a chooser
        }
        Connections {
            target: contentItemLoader.item
            function onSetupTitle(newTitle) {
                rootItem.tileTitle = newTitle;
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

    function serializeSession() {
        // get content for the tile
        var tileItem = contentItemLoader.item;
        var tileContent = {};
        if(tileItem && tileItem.serializeSession) tileContent = tileItem.serializeSession();

        return {
            "source": contentItemLoader.source,
            "content": tileContent
        };
    }
    function deserializeSession(sessionObject) {
        contentItemLoader.source = sessionObject.source; // this will load the corresponding tile

        if(contentItemLoader.item && contentItemLoader.item.deserializeSession)
            contentItemLoader.item.deserializeSession(sessionObject.content);
    }
}
