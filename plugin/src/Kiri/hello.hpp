#pragma once

#include <QObject>
#include <QString>
#include <QtQml/qqmlregistration.h>
#include <iostream>

class Hello : public QObject {
    Q_OBJECT
    QML_ELEMENT

  public:
    explicit Hello(QObject *parent = nullptr) : QObject(parent) {
        std::cout << "Hello, world!" << std::endl;
    }

    Q_INVOKABLE QString getValue();
};