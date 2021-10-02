import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "Models"

Item {
    id: rootItem
    height: dragRect.height;
    width: parent ? parent.width : 80;

    property TileModel tileModel

    signal close();

    property alias tileTitle: tileTitleText.text
    property alias backgroundColor: dragRect.color
    property bool expanded: true

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
        height: titleRect.height + (contentItemLoader.visible ? contentItemLoader.height : 0) + 2*border.width

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

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                drag.target: dragRect

                drag.onActiveChanged: {
                    dragRect.Drag.drop();
                }
            }

            RowLayout {
                anchors.fill: parent
                spacing: 5
                Button {
                    padding: 0
                    display: AbstractButton.TextOnly
                    background: Item {}
                    Layout.preferredHeight: parent.height
                    Layout.preferredWidth: parent.height
                    rotation: rootItem.expanded ? 0 : -90
                    Behavior on rotation { NumberAnimation { duration: 100 } }
                    text: "▼"
                    onClicked: rootItem.expanded = !rootItem.expanded
                }
                Text {
                    id: tileTitleText
                    Layout.fillWidth: true
                    text: tileModel.title
                    font.pixelSize: 12
                    font.bold: true
                    elide: Text.ElideRight
                    color: "darkblue"
                }
                Button {
                    visible: (!!contentItemLoader.item && !!contentItemLoader.item.optionsDialog)
                    padding: 0
                    background: Item {}
                    icon.source: "qrc:///TileManager/images/options.svg"
                    icon.height: parent.height
                    icon.width: parent.height
                    Layout.preferredHeight: parent.height
                    Layout.preferredWidth: height
                    onClicked: contentItemLoader.item.optionsDialog.open();
                }
                Button {
                    padding: 0
                    background: Item {}
                    icon.source: "qrc:///TileManager/images/close.svg"
                    icon.color: "transparent"
                    icon.height: parent.height
                    icon.width: parent.height
                    Layout.preferredHeight: parent.height
                    Layout.preferredWidth: height
                    onClicked: rootItem.close();
                }
            }
        }

        Loader {
            id: contentItemLoader
            visible: rootItem.expanded
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
                if(item && !!item.tileTitle) {
                    tileModel.title = item.tileTitle;
                }
            }
        }
        Connections {
            target: contentItemLoader.item
            function onSetupTitle(newTitle) {
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
