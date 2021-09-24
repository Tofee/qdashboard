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
import QtQuick.Window 2.0

Item {
    id: root

    width: 800
    height: 480

    property string place: "Paris,France"

    Item {
        id: slideshow

        anchors.fill: parent

        Text {
            id: clockText

            anchors.left: dateText.left
            anchors.baseline: temperatureText.baseline

            text: {
                var date = new Date()
                return date.toLocaleTimeString(Qt.locale(), "hh:mm");
            }

            font.pixelSize: 80
        }

        Text {
            id: dateText

            anchors.left: parent.left
            anchors.top: clockText.bottom
            anchors.leftMargin: 20

            text: {
                var date = new Date()
                return date.toLocaleDateString();
            }

            font.pixelSize: 20
        }

        Text {
            id: temperatureText

            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottomMargin: 20
            anchors.rightMargin: 20

            text: weatherModel.currentTempC.toFixed(1) + "°C"

            font.pixelSize: 80
        }

        ListView {
            id: weatherRow

            orientation: ListView.Horizontal

            anchors.top: dateText.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            anchors.bottomMargin: 20

            clip: true;

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
                        return date.toLocaleString(Qt.locale(), "dd/MM hh:mm");
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

        Text {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: 5
            anchors.rightMargin: 20
            text: "OpenWeatherData"
            font.pixelSize: 12
            font.italic: true
        }
    }

    function serializeSession() {
        // get content for the tile
        return {
            "place": root.place
        };
    }
    function deserializeSession(sessionObject) {
        root.place = sessionObject.place;
    }
}