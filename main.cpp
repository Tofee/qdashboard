#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtGlobal>
#include <QUrlQuery>

#include <stdio.h>
#include <stdlib.h>

#include <emscripten/val.h>

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
    QGuiApplication app(argc, argv);

    app.setOrganizationName(QStringLiteral("Tofe"));
    app.setApplicationName(QStringLiteral("QDashboard"));

    QString username("guest");

    emscripten::val location = emscripten::val::global("location");
    QString hostname = QString::fromEcmaString(location["hostname"]);
    QString search = QString::fromEcmaString(location["search"]); // to retrieve the arguments
    
    QString serverBaseURI(QString("https://%1%2").arg(hostname).arg(QDASHBOARD_SERVER_BASE_URI));
    
    QUrlQuery qQuery(search.removeFirst());
    if (qQuery.hasQueryItem("user"))
        username = qQuery.queryItemValue("user");

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
           { "serverBaseURI", serverBaseURI },
           { "openweatherApiKey", QString(STR(OPENWEATHER_API_KEY)) },
           { "serverUsername", username }
    });

    appEngine.load(url);
    return app.exec();
}
