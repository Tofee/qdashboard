import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: item
    property color selected_color: group.checkedButton ? group.checkedButton.target_color : "white"

    implicitWidth: grid.width
    implicitHeight: grid.height

    ButtonGroup {
        id: group
        buttons: grid.children
    }

    Grid {
        id: grid
        columns: 9
        columnSpacing: 0
        rowSpacing: 0

        Repeater {
            model: [
                "black",     "#705958", "red",     "#c90002", "#9d0000", "#b20093", "#c978b8", "#8d0073", "#750161",
                "gray" ,     "#8366b4", "purple",  "#51127c", "#400061", "#5361b5", "#1b3d9f", "#152c81", "#061967",
                "darkgray",  "#5188ca", "blue",    "#004d90", "#003d75", "#02afae", "#008c8a", "#017071", "#36c590",
                "lightgray", "#56c222", "green",   "#018944", "#006f35", "#fcf471", "yellow",  "#cdc101", "#a39700",
                "white",     "#fdc667", "#fea200", "#cb8001", "#a66400", "#ffa566", "#ff7c00", "#cf6402", "#a54b00"
            ]
            delegate: PaletteCheckBox {
                target_color: modelData
            }
        }
    }
}
