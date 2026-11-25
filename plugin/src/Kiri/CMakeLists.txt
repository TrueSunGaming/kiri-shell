qt_add_qml_module(KiriQsPlugin
    URI KiriPlugin
    SOURCES
        hello.hpp
        hello.cpp
)

target_link_libraries(KiriQsPlugin PRIVATE Qt6::Core Qt6::Qml)