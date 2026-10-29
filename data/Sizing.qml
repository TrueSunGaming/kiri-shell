pragma Singleton

import Quickshell

Singleton {
    readonly property real phi: 1.618

    readonly property real fontSize: 12

    function relative(base: real, steps: real): real {
        return base * phi ** steps;
    }

    readonly property real sizeMicro: relative(fontSize, -2.5)
    readonly property real sizeXXS: relative(fontSize, -1.5)
    readonly property real sizeXS: relative(fontSize, -1)
    readonly property real sizeS: relative(fontSize, -0.5)
    readonly property real sizeM: fontSize
    readonly property real sizeL: relative(fontSize, 0.5)
    readonly property real sizeXL: relative(fontSize, 1)
    readonly property real sizeXXL: relative(fontSize, 1.5)

    readonly property real barSize: sizeM * 2

    readonly property real mediaImageSize: relative(fontSize, 5)
}
