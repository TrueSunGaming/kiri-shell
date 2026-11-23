cmake_minimum_required(VERSION 3.16)
project(KiriQsPlugin LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(Qt6 REQUIRED COMPONENTS Core Qml)
qt_standard_project_setup(REQUIRES 6.12)

qt_add_qml_module(KiriQsPlugin
    URI KiriPlugin
    OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/KiriPlugin
    SOURCES
        src/Kiri/hello.hpp
        src/Kiri/hello.cpp
)

target_include_directories(KiriQsPlugin PRIVATE src/Kiri)
target_link_libraries(KiriQsPlugin PRIVATE Qt6::Core Qt6::Qml)