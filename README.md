QDashboard
==========

Simple dashboard to visualize content in tiles.

Build and Run
-------------

In other to fully work, QDashboard need a server-side companion, provided by the qdashboard-server repository.

In order to be able to retrieve weather data, a weather_api_key.cmake must be created beside the CMakeLists.txt file, with the following content (replace the dummy key with your own OpenWeather API key here):
```
set (OPENWEATHER_API_KEY 0123456789abcdef)
```

Building to WebAssembly can be done simply with the help of the stateoftheartio/qt6:6.6-wasm-aqt docker image. Pull it, and then just adapt and start ./build-wasm.sh.
Then copy the output files to your web server:
```
scp ../build-QDashboard-WebAssembly-Release/QDashboard.* ../build-QDashboard-WebAssembly-Release/qtlo* myserver:/var/www/html/qdashboard
```
