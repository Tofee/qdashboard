// Row of columns, covering the whole width

import QtQuick 2.15
import QtQuick.Layouts 1.12
import QtQml.Models 2.12
import QtQuick.Controls 2.15

RowLayout {
    id: rowLayout
    spacing: 0
    property ObjectModel listObjectColumns: ObjectModel {}

    Component {
        id: columnComponent
        Item {
            id: titleColumnWrapper
            property real weight: 1.0 // by defautl, each column weights the same. Total weight is always listObjectColumns.count.
            property Item wrappedColumn: titleColumn

            Layout.preferredHeight: titleColumn.height
            Layout.alignment: Qt.AlignTop
            Layout.minimumWidth: 100
            Layout.preferredWidth: rowLayout.width*(weight/listObjectColumns.count);

            property real _minWeight: (Layout.minimumWidth/rowLayout.width)*listObjectColumns.count;

            TileColumn {
                id: titleColumn
                width: parent.width - colHandle.width
                anchors.left: parent.left
                anchors.top: parent.top

                onAddColumn: rowLayout.addColumn();

                Component.onDestruction: {
                    for(var i=0; i<listObjectColumns.count; ++i) {
                        if(listObjectColumns.get(i) === this.parent) {
                            listObjectColumns.remove(i);
                            break;
                        }
                    }

                    if(listObjectColumns.count === 0) {
                        rowLayout.destroy();
                    }
                }
            }
            // handle
            Rectangle {
                id: colHandle
                anchors.left: titleColumn.right
                anchors.top: parent.top
                width: 4
                height: titleColumn.height
                color: "red"

                MouseArea {
                    anchors.fill: parent
                    drag{ target: parent; axis: Drag.XAxis }
                    onMouseXChanged: {
                        if(drag.active) {
                            var newWidth = titleColumnWrapper.width + mouseX;
                            var deltaWeight = newWidth*listObjectColumns.count/rowLayout.width - titleColumnWrapper.weight;
                            if (_minWeight < titleColumnWrapper.weight + deltaWeight &&
                                _minWeight < listObjectColumns.get(titleColumnWrapper.ObjectModel.index+1).weight - deltaWeight)
                            {
                                titleColumnWrapper.weight += deltaWeight;
                                listObjectColumns.get(titleColumnWrapper.ObjectModel.index+1).weight -= deltaWeight;
                            }
                        }
                    }
                }
            }

            function addTile() {
                titleColumn.addTile();
            }
            function serializeSession() {
                return titleColumn.serializeSession();
            }
            function deserializeSession(sessionObject) {
                titleColumn.deserializeSession(sessionObject);
            }
        }
    }

    Repeater {
        model: listObjectColumns
    }

    function addColumn()
    {
        var newColumn = columnComponent.createObject(listObjectColumns);
        listObjectColumns.append(newColumn);

        newColumn.addTile();
    }

    function serializeSession() {
        // get content for each column in the splitview
        var columnArray = new Array;
        for (var i = 0; i < listObjectColumns.count; ++i) {
            var column = listObjectColumns.get(i).serializeSession();
            columnArray.push(column);
        }

        return {
            "columns": columnArray
        };
    }
    function deserializeSession(sessionObject) {
        for(var i = 0; i < sessionObject.columns.length; ++i) {
            var newColumn = columnComponent.createObject(listObjectColumns);
            newColumn.deserializeSession(sessionObject.columns[i]);

            listObjectColumns.append(newColumn);
        }
    }
}
