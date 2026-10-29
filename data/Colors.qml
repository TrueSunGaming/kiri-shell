pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property real accentHue: 178 / 360
    readonly property real accentSaturation: 0.54
    readonly property real accentLightness: 0.48
    readonly property color accent: Qt.hsla(accentHue, accentSaturation, accentLightness, 1)

    readonly property color text: Qt.hsla(0, 0, 0.95, 1)
    readonly property color secondaryText: Qt.darker(text, 1.3)
    readonly property color disabledText: Qt.darker(text, 1.5)

    readonly property color error: Qt.hsla(0, 0.8, 0.5, 1)

    readonly property color shield: createShield(0.29, 0.1)
    readonly property color inverseShield: createShield(0.05, 0.45)

    readonly property real glassBorderOpacity: shield.a / 1.5
    readonly property color glassBorder: Qt.alpha(Qt.lighter(shield, 2.5), glassBorderOpacity)

    readonly property color popupGradStart: Qt.alpha("#202020", 0.4)
    readonly property color popupGradEnd: Qt.alpha("#282828", 0.45)

    function createShield(dark: real, light: real): color {
        const alpha = dark + light;
        const brightness = light / alpha;
        return Qt.rgba(brightness, brightness, brightness, alpha);
    }

    function blendColor(c1: color, c2: color, ratio: real): color {
        const r = c1.r * c1.a + c2.r * c2.a;
        const g = c1.g * c1.a + c2.g * c2.a;
        const b = c1.b * c1.a + c2.b * c2.a;
        const a = c1.a + c2.a
        return Qt.rgba(r / a, g / a, b / a, a)
    }

    function toHex(color: color): string {
        const a = Math.round(color.a * 255).toString(16).padStart(2, "0");
        const r = Math.round(color.r * 255).toString(16).padStart(2, "0");
        const g = Math.round(color.g * 255).toString(16).padStart(2, "0");
        const b = Math.round(color.b * 255).toString(16).padStart(2, "0");
        return `#${a}${r}${g}${b}`;
    }
}
