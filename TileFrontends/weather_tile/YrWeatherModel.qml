import QtQuick 2.12

ListModel {
    id: weatherModel

    property int refreshHour: 1     // How often is the model refreshed (in hours)
    property string place: "Paris,France"           // Place, URL encoded and according to Yr web site, e.g. Sweden/V%C3%A4stra_G%C3%B6taland/Alings%C3%A5s

    property real currentTempC;

    property Timer refreshTimer: Timer {
        interval: 3600000 * weatherModel.refreshHour
        running: true
        repeat: true
        onTriggered: {
            weatherModel.reload();
        }
    }

    // Retry every five minutes if we get an error
    property Timer errorRetryTimer: Timer {
        interval: 300000
        repeat: false
        onTriggered: {
            weatherModel.reload();
        }
    }

    Component.onCompleted: reload();

    function reload() {
        weatherModel.clear();

        var xhr = new XMLHttpRequest;
        xhr.open("GET", serverBaseURI+"/weather_tile/forecast/"+openweatherApiKey+"/"+place);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if(xhr.status !== 200) errorRetryTimer.start();

                var rootObj = JSON.parse(xhr.responseText);
                var nbIntervals = rootObj.list.length

                for(var i = 0; i< nbIntervals; ++i)
                {
                    var listItem = rootObj.list[i];
                    var symbol = listItem.weather[0].icon;
                    if(!symbol.endsWith("@2x")) symbol += "@2x";
                    var period = i;

                    weatherModel.append({
                                            "epochDate":listItem.dt*1000,
                                            "symbol":symbol,
                                            "symbolSource":"images/weather/" + symbol + ".png",
                                            "temperature":listItem.main.temp - 273.15,
                                            "precipitation":listItem.main.humidity
                                        });
                }

                if(nbIntervals>0) weatherModel.currentTempC = rootObj.list[0].main.temp - 273.15;
            }
        }
        xhr.send();
    }
}
