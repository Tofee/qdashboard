cmake_minimum_required(VERSION 3.16)
project(QDashboard VERSION 1.0 LANGUAGES C CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

find_package(QT NAMES Qt6 REQUIRED COMPONENTS Core)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Gui Quick)

set (OPENWEATHER_API_KEY "")
include (weather_api_key.cmake OPTIONAL)

qt_standard_project_setup()

qt_add_executable(QDashboard WIN32 MACOSX_BUNDLE
    main.cpp
)
target_compile_definitions(QDashboard PRIVATE
    QT_DEPRECATED_WARNINGS
    OPENWEATHER_API_KEY=${OPENWEATHER_API_KEY}
)

target_link_libraries(QDashboard PRIVATE
    Qt::Core
    Qt::Gui
    Qt::Quick
)


# Resources:
set(qml_resource_files
    "TileFrontends/rss_tile/RssTile.qml"
    "TileFrontends/text_tile/TextTile.qml"
    "TileFrontends/todo_tile/TodoTile.qml"
    "TileFrontends/weather_tile/WeatherTile.qml"
    "TileFrontends/weather_tile/YrWeatherModel.qml"
    "TileFrontends/weather_tile/images/weather/01d.png"
    "TileFrontends/weather_tile/images/weather/01n.png"
    "TileFrontends/weather_tile/images/weather/02d.png"
    "TileFrontends/weather_tile/images/weather/02n.png"
    "TileFrontends/weather_tile/images/weather/03d.png"
    "TileFrontends/weather_tile/images/weather/03n.png"
    "TileFrontends/weather_tile/images/weather/04d.png"
    "TileFrontends/weather_tile/images/weather/04n.png"
    "TileFrontends/weather_tile/images/weather/09d.png"
    "TileFrontends/weather_tile/images/weather/09n.png"
    "TileFrontends/weather_tile/images/weather/10d.png"
    "TileFrontends/weather_tile/images/weather/10n.png"
    "TileFrontends/weather_tile/images/weather/11d.png"
    "TileFrontends/weather_tile/images/weather/11n.png"
    "TileFrontends/weather_tile/images/weather/13d.png"
    "TileFrontends/weather_tile/images/weather/13n.png"
    "TileFrontends/weather_tile/images/weather/50d.png"
    "TileFrontends/weather_tile/images/weather/50n.png"
    "TileManager/Models/RowOfColumnsModel.qml"
    "TileManager/Models/RowsModel.qml"
    "TileManager/Models/TabsModel.qml"
    "TileManager/Models/TileColumnModel.qml"
    "TileManager/Models/TileModel.qml"
    "TileManager/PaletteCheckBox.qml"
    "TileManager/PaletteChooser.qml"
    "TileManager/RowOfColumns.qml"
    "TileManager/TabPage.qml"
    "TileManager/Tile.qml"
    "TileManager/TileChooser.qml"
    "TileManager/TileColumn.qml"
    "TileManager/TileContentBase.qml"
    "TileManager/images/close.svg"
    "TileManager/images/options.svg"
    "TileManager/images/white-waves.png"
    "main.qml"
)

qt_add_resources(QDashboard "qml"
    PREFIX
        "/"
    FILES
        ${qml_resource_files}
)

set_target_properties(QDashboard PROPERTIES QT_WASM_EXTRA_EXPORTED_METHODS "ENV")

install(TARGETS QDashboard
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

qt_generate_deploy_app_script(
    TARGET QDashboard
    FILENAME_VARIABLE deploy_script
    NO_UNSUPPORTED_PLATFORM_ERROR
)
install(SCRIPT ${deploy_script})
