#include <QGuiApplication>
#include <QQmlApplicationEngine>

#if 0
#define KDDOCKWIDGETS_QTQUICK 1

#include <kddockwidgets/DockWidgetQuick.h>
#include <kddockwidgets/Config.h>
#include <kddockwidgets/private/DockRegistry_p.h>
#include <kddockwidgets/FrameworkWidgetFactory.h>

// clazy:excludeall=qstring-allocations

using namespace KDDockWidgets;
#endif

int main(int argc, char *argv[])
{
#if 0
#ifdef QT_STATIC
    Q_INIT_RESOURCE(kddockwidgets_resources);
#endif
#endif

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);
#endif
    QGuiApplication app(argc, argv);

    app.setOrganizationName(QStringLiteral("Tofe"));
    app.setApplicationName(QStringLiteral("Test app"));

    QQmlApplicationEngine appEngine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    // if creation failed, exit immediatly
    QObject::connect(&appEngine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                                     if (!obj && url == objUrl)
                                         QCoreApplication::exit(-1);
                                 }, Qt::QueuedConnection);
    appEngine.load(url);

#if 0
    // Create your engine which loads main.qml. A simple QQuickView would work too.
    KDDockWidgets::Config::self().setQmlEngine(&appEngine);

    // Below we illustrate usage of our C++ API. Alternative you can use declarative API.
    // See main.qml for examples of dockwidgets created directly in QML

    auto dw1 = new KDDockWidgets::DockWidgetQuick("Dock #1");
    dw1->setWidget(QStringLiteral("qrc:/rss_tile/RssTile.qml"));
    dw1->resize(QSize(400, 200));
    dw1->show();

    auto dw2 = new KDDockWidgets::DockWidgetQuick("Dock #2");
    dw2->setWidget(QStringLiteral("qrc:/text_tile/TextTile.qml"));
    dw2->resize(QSize(400, 200));
    dw2->show();

    auto dw3 = new KDDockWidgets::DockWidgetQuick("Dock #3");
    dw3->setWidget(QStringLiteral("qrc:/text_tile/TextTile.qml"));
    dw2->resize(QSize(400, 200));
    dw3->show();

    auto dw4 = new KDDockWidgets::DockWidgetQuick("Dock #4");
    dw4->setWidget(QStringLiteral("qrc:/rss_tile/RssTile.qml"));
    dw4->resize(QSize(400, 200));
    dw4->show();

    KDDockWidgets::MainWindowBase *mainWindow = KDDockWidgets::DockRegistry::self()->mainwindows().constFirst();

    mainWindow->addDockWidget(dw1, KDDockWidgets::Location_OnTop);
    mainWindow->addDockWidget(dw2, KDDockWidgets::Location_OnBottom);
    mainWindow->addDockWidget(dw3, KDDockWidgets::Location_OnRight, dw2);
    mainWindow->addDockWidget(dw4, KDDockWidgets::Location_OnRight, dw3);
#endif
    return app.exec();
}
