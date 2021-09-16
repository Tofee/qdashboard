import QtQuick 2.0

Item {
    id: rootItem
    height: 80; width: parent ? parent.width : 80;
    property color color: "red"

    default property alias _data: contentItem.data

    // draw a frame:
    // _______________
    // |    title    |
    // - - - - - - - -
    // |             |
    // |   WIDGET    |
    // |             |
    // ---------------

    // bacground and border
    Rectangle {
        id: dragRect
        color: rootItem.color
        border {
            color: "grey"
            width: 1
        }
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: rootItem.width
        height: rootItem.height

        // drag and drop
        property Item parentTile: rootItem;

        // title + its background
        Rectangle {
            id: titleRect
            color: "lightblue"
            height: titleTitleText.implicitHeight*1.1
            anchors
            {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            anchors.margins: parent.border.width

            Text {
                id: titleTitleText
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

        Item {
            id: contentItem
            anchors
            {
                top: titleRect.bottom
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }
            anchors.margins: parent.border.width
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
