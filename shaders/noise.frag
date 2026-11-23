#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec4 tintColor;
    float noiseIntensity;
    vec2 resolution;
};

layout(binding = 1) uniform sampler2D mask;

float hash12(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

void main() {
    vec4 maskColor = texture(mask, qt_TexCoord0);
    vec2 pixelPos = qt_TexCoord0 * resolution;

    float n = hash12(pixelPos) - 0.5;
    
    vec3 finalRgb = vec3(0.5) + n * noiseIntensity;
    float finalAlpha = tintColor.a * maskColor.a * qt_Opacity;

    fragColor = vec4(finalRgb * finalAlpha, finalAlpha);
}