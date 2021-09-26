// Row of columns, covering the whole width

import QtQuick 2.15
import QtQuick.Layouts 1.12
import QtQml.Models 2.12
import QtQuick.Controls 2.15

import "Models"

RowLayout {
    id: rowLayout
    spacing: 0

    property RowOfColumnsModel columnsModel

    signal removeRow();

    Repeater {
        model: columnsModel
        delegate: Item {
            id: titleColumnWrapper
            readonly property real weight: content.weight
            property TileColumnModel tileColumnModel: content

            property int columnIndex: index

            Layout.preferredHeight: titleColumn.height
            Layout.alignment: Qt.AlignTop
            Layout.minimumWidth: 100
            Layout.preferredWidth: rowLayout.width*(weight/columnsModel.count);

            property real _minWeight: (Layout.minimumWidth/rowLayout.width)*columnsModel.count;

            TileColumn {
                id: titleColumn
                width: parent.width - colHandle.width - 2*3
                anchors.left: parent.left
                anchors.top: parent.top

                tileColumnModel: titleColumnWrapper.tileColumnModel

                onAddColumn: columnsModel.addColumn();
                onRemoveColumn: {
                    if(columnsModel.count === 0) {
                        rowLayout.removeRow();
                    }
                    else {
                        columnsModel.remove(titleColumnWrapper.columnIndex);
                    }
                }
            }
            // handle
            Rectangle {
                id: colHandle
                visible: titleColumnWrapper.columnIndex+1 < columnsModel.count
                anchors.left: titleColumn.right
                anchors.top: parent.top
                anchors.leftMargin: 3
                anchors.rightMargin: 3
                width: 2

                height: Math.min(titleColumn.height, 50)
                color: "grey"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.SplitHCursor
                    drag{ target: parent; axis: Drag.XAxis }
                    onMouseXChanged: {
                        if(drag.active) {
                            var newWidth = titleColumnWrapper.width + mouseX;
                            var deltaWeight = newWidth*columnsModel.count/rowLayout.width - titleColumnWrapper.weight;
                            var columnOnRight = columnsModel.get(titleColumnWrapper.columnIndex+1).content;
                            if (_minWeight < titleColumnWrapper.weight + deltaWeight &&
                                _minWeight < columnOnRight.weight - deltaWeight)
                            {
                                titleColumnWrapper.tileColumnModel.weight += deltaWeight;
                                columnOnRight.weight -= deltaWeight;
                            }
                        }
                    }
                }
            }
        }
    }
}
