import QtQuick 2.12

ListModel {
    id: tabsModel

    property Component _childTemplate: Component {
        RowsModel {}
    }

    function addTab()
    {
        var newTabPage = _childTemplate.createObject(tabsModel);
        tabsModel.append({"content": newTabPage, "title": ("New tab " + tabsModel.count)});
    }

    function serializeSession() {
        // get content for each tab page
        var tabPageArray = new Array;
        for (var i = 0; i < tabsModel.count; ++i) {
            var tabPage = tabsModel.get(i).content;
            var tabPageSerialized = tabPage.serializeSession();
            // add title
            tabPageSerialized.title = tabsModel.get(i).title;

            tabPageArray.push(tabPageSerialized);
        }

        return {
            "tabs": tabPageArray
        };
    }
    function deserializeSession(sessionObject) {
        for(var i = 0; i < sessionObject.tabs.length; ++i) {
            var newTabPage = _childTemplate.createObject(tabsModel);
            newTabPage.deserializeSession(sessionObject.tabs[i]);

            tabsModel.append({
                                 "content": newTabPage,
                                 "title": (sessionObject.tabs[i].title || "Tab")
                             });
        }
    }
}
