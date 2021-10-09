import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../../TileManager"

TileContentBase {
    id: rootItem

    height: todoListColumn.height
    tileTitle: "My ToDo List"

    ListModel {
        id: todoModel
    }

    Column {
        id: todoListColumn
        width: parent.width

        Component {
            id: todoItemComp

            RowLayout {
                id: todoItem

                width: todoListColumn.width

                property int _index: index

                CheckBox {
                    padding: 0
                    font.pixelSize: 12
                    text: title

                    Layout.fillWidth: true

                    checkState: completed ? Qt.Checked : Qt.Unchecked
                    onCheckStateChanged: {
                        todoModel.setProperty(_index, "completed", (checkState===Qt.Checked));

                        saveToModel();
                    }
                }
                RoundButton {
                    radius: 10
                    Layout.preferredHeight: 20
                    Layout.preferredWidth: 20
                    padding: 2
                    font.pixelSize: 12
                    text: "X"
                    hoverEnabled: true
                    palette.button: hovered ? "tomato" : "lightgrey"
                    onClicked: todoModel.remove(_index);
                }
            }
        }

        Repeater {
            model: todoModel
            delegate: todoItemComp
        }

        // footer
        Rectangle {
            id: newTodoRow
            height: newTodoInput.implicitHeight
            width: parent.width
            color: "#eee"

            TextField {
                id: newTodoInput
                anchors.left: parent.left
                anchors.right: newTodoButton.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 10
                color: "black"
                placeholderText: "What needs to be done?"
                placeholderTextColor: "#ccc"
                font.pixelSize: 12

                onEditingFinished: newTodoButtonArea.clicked({});
            }

            Rectangle {
                id: newTodoButton
                width: 30
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                color: newTodoButtonArea.containsMouse ? "#27b039" : "#37c049"

                Text {
                    anchors.centerIn: parent
                    text: "+"
                    color: "white"
                }

                MouseArea {
                    id: newTodoButtonArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if (newTodoInput.text.length === 0)
                            return;

                        todoModel.append({
                                    "completed": false,
                                    "title": newTodoInput.text
                                    });

                        newTodoInput.text = "";

                        saveToModel();
                    }
                }
            }
        }
    }

    function saveToModel() {
        var todoArray = new Array;
        for(var i=0; i<todoModel.count; ++i) {
            todoArray.push({"title": todoModel.get(i).title, "completed": todoModel.get(i).completed});
        }
        commitContent({
            "todoList": todoArray
        });
    }
    function initFromModel(tileModelContent) {
        todoModel.clear();
        for(var idx in tileModelContent.todoList) {
            todoModel.append(tileModelContent.todoList[idx]);
        }
    }
}





