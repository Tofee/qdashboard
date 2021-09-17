import QtQuick 2.0

Item {
    id: rootItem
    height: dragRect.height;
    width: parent ? parent.width : 80;

    property alias tileTitle: tileTitleText.text
    property alias backgroundColor: dragRect.color

    default property alias contentItemSource: contentItemLoader.source

    // draw a frame:
    // _______________
    // |    title    |
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
