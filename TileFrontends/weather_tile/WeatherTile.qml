/*
 * hassframe-ui - the user interface of a hass.io photo frame
 * Copyright (C) 2018 Johan Thelin
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 */

import QtQuick 2.7
import QtQuick.Layouts 1.12

import "../../TileManager"

TileContentBase {
    id: root

    height: contentItem.height

    property string place: "Paris,France"

    Item {
        id: contentItem
        width: parent.width
        height: infosGrid.height + 150 /* for the listview */

        Column {
            id: infosGrid
            width: parent.width
            clip: true

            RowLayout {
                width: parent.width
                Text {
                    id: placeText
                    text: root.place
                    font.pixelSize: 20
                }
                Text {
                    id: dateText
                    Layout.alignment: Qt.AlignRight
                    text: {
                        var date = new Date()
                        return date.toLocaleDateString(Qt.locale(), "ddd dd MMM yyyy");
                    }
                    font.pixelSize: 20
                }
            }
            RowLayout {
                width: parent.width
                Text {
                    id: clockText
                    text: {
                        var date = new Date()
                        return date.toLocaleTimeString(Qt.locale(), "hh:mm");
                    }
                    font.pixelSize: 28
                }
                Text {
                    id: temperatureText
                    Layout.alignment: Qt.AlignRight
                    text: weatherModel.currentTempC.toFixed(1) + "°C"
                    font.pixelSize: 28
                }
            }
        }

        ListView {
            id: weatherRow

            orientation: ListView.Horizontal

            anchors.top: infosGrid.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 20

            clip: true

            model: weatherModel
            spacing: 10
            delegate: Column {
                spacing: 2
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 12
                    font.bold: true
                    text: {
                        var date = new Date(epochDate)
                        return date.toLocaleString(Qt.locale(), "ddd hh:mm");
                    }
                }
                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: symbolSource
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 12
                    font.bold: true
                    text: precipitation + "%"
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 12
                    font.bold: true
                    text: temperature.toFixed(1) + "°C"
                }
            }
        }

        YrWeatherModel {
            id: weatherModel
            place: root.place
        }
    }

    function saveToModel() {
        commitContent({
            "place": root.place
        });
    }
    function initFromModel(tileModelContent) {
        root.place = tileModelContent.place;
    }
}
