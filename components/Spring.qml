import QtQuick

SpringAnimation {
    property real target90Time: 0.2

    /*
    Coefficient derived from critically damped spring: x_t=e^{-\gamma t}(x_0+v_0t+x_0\gamma t)
    where x_t=0.1 (90% complete), x_0=1, v_0=0, m=1, \gamma=c/(2m)=\sqrt(k/m) (critically damped)

    principal branch: k=(W_{0}(-0.1/e)+1)^2*t^{-2} = 0.925018 (works here)
    secondary real branch: k=(W_{-1}(-0.1/e)+1)^2*t^{-2} = 15.129923 (works in hyprland config)
    */
    property real springConstant: 15.129923 * target90Time ** -2

    mass: 1
    spring: springConstant / 30
    damping: 0.95
}
