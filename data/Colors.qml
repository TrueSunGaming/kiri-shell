pragma Singleton

import QtQuick
import Quickshell
import qs.services

Singleton {
    readonly property real accentHue: Config.data.style.colors.accentHue / 360
    readonly property real accentSaturation: Config.data.style.colors.accentSaturation
    readonly property real accentLightness: Config.data.style.colors.accentLightness
    readonly property color accent: Qt.hsla(accentHue, accentSaturation, accentLightness, 1)

    readonly property color text: Qt.hsla(0, 0, 0.95, 1)
    readonly property color secondaryText: Qt.darker(text, 1.3)
    readonly property color disabledText: Qt.darker(text, 1.5)

    readonly property color error: Qt.hsla(0, 0.8, 0.5, 1)

    readonly property color baseShield: createShield(0.32, 0.08)
    readonly property real shieldTint: 0.07
    readonly property color shield: createAccentShield(shieldTint)
    readonly property color subShield: createSubShield(shield)
    readonly property real accentShieldTint: 0.5
    readonly property color accentShield: createAccentShield(accentShieldTint)
    readonly property color accentSubShield: createSubShield(accentShield)

    readonly property real glassBorderOpacity: 0.5

    readonly property color popupGradStart: Qt.alpha("#202020", 0.4)
    readonly property color popupGradEnd: Qt.alpha("#282828", 0.45)

    function tintConstAlpha(base: color, tint: color): color {
        return Qt.alpha(Qt.tint(base, tint), base.a);
    }

    function createShield(dark: real, light: real): color {
        const alpha = dark + light;
        const brightness = light / alpha;
        return Qt.rgba(brightness, brightness, brightness, alpha / 3 + 0.33);
    }

    function createSubShield(shield: color): color {
        return Qt.alpha(shield, shield.a / 2);
    }

    function createAccentShield(tint: real): color {
        return tintConstAlpha(baseShield, Qt.alpha(accent, tint));
    }

    function createGlassBorder(shield: color): color {
        return Qt.alpha(Qt.lighter(shield, 2.5), shield.a * glassBorderOpacity);
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
