#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtGlobal>

#include <stdio.h>
#include <stdlib.h>

// Propose a fallback value for qdashboard-server root URI
#ifndef QDASHBOARD_SERVER_BASE_URI
#define QDASHBOARD_SERVER_BASE_URI "/qdashboard/api"
#endif
#ifndef OPENWEATHER_API_KEY
#define OPENWEATHER_API_KEY 0123456789abcdef
#endif

#define _STR(x) #x
#define STR(x) _STR(x)

void myMessageOutput(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    QByteArray localMsg = msg.toLocal8Bit();
    QString strType = "";
    FILE *output = stderr;
    switch (type) {
    case QtDebugMsg: strType = "Debug"; break;
    case QtInfoMsg: strType = "Info"; break;
    case QtWarningMsg: strType = "Warning"; output = stderr; break;
    case QtCriticalMsg: strType = "Critical"; output = stderr; break;
    case QtFatalMsg: strType = "Fatal"; output = stderr; break;
    }

    fprintf(output, "%s (%s:%u, %s): %s\n", strType.toLocal8Bit().constData(), context.file, context.line, context.function, localMsg.constData());
}

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);

//    QGuiApplication::setAttribute(Qt::AA_DisableHighDpiScaling);
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

    qInstallMessageHandler(myMessageOutput); // Install the handler

    appEngine.setInitialProperties({
           { "serverBaseURI", QString(QDASHBOARD_SERVER_BASE_URI) },
           { "openweatherApiKey", QString(STR(OPENWEATHER_API_KEY)) }
    });

    appEngine.load(url);
    return app.exec();
}
