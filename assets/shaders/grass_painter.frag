#include <flutter/runtime_effect.glsl>

precision mediump float;

out vec4 fragColor;
uniform float uSizeX;
uniform float uSizeY;
uniform float uTextureSizeX;
uniform float uTextureSizeY;
uniform sampler2D image;

void main() {
    vec2 iResolution = vec2(uSizeX, uSizeY);
    vec2 iTextureSize = vec2(uTextureSizeX, uTextureSizeY);
    vec2 fragCoord = FlutterFragCoord();
    vec2 uv = fragCoord / iResolution.xy;

    // Scaling the UV coordinates to fill the entire screen
    vec2 tiledUV = uv * (iResolution / iTextureSize);

    // We use the module to create texture tiling (seamless tiling)
    tiledUV = mod(tiledUV, 1.0);

    // We get the color from the texture using tiling-UV
    fragColor = texture(image, tiledUV);
}

