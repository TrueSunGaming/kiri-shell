cmake_minimum_required(VERSION 3.16)
project(KiriQsPlugin LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(Qt6 REQUIRED COMPONENTS Core Qml)

set(QT_QML_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/KiriPlugin")
qt_standard_project_setup(REQUIRES 6.12)

add_subdirectory(src/Kiri)