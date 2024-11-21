#include <flutter/runtime_effect.glsl>

precision mediump float;

out vec4 fragColor;
uniform float iTime;
uniform float uSizeX;
uniform float uSizeY;
uniform float uTextureSizeX;
uniform float uTextureSizeY;
uniform float uSpriteCount;
uniform float uColorR;
uniform float uColorG;
uniform float uColorB;
uniform sampler2D image;

// We limit the number of sprites in the set,
// because constant constraints are needed for the array to work
const int MAX_TILES_COUNT = 32;

// -------------------------------------------------------------------------------------------------
void main() {
    vec2 iResolution = vec2(uSizeX, uSizeY);
    vec2 iTextureSize = vec2(uTextureSizeX, uTextureSizeY);
    vec2 fragCoord = FlutterFragCoord();

    // the shade in which we color the texture
    vec3 overlayColor = vec3(
        uColorR / 255,
        uColorG / 255,
        uColorB / 255
    );

    float uSpeed = 0.09;

    // ---- rotation --------------------------------------------------
    // Rotation angle
    float uRotation = iTime;

    // shifting the coordinates for rotation relative to the center
    vec2 uv = fragCoord / iResolution - 0.5;
    mat2 rotationMatrix = mat2(
        cos(uRotation), -sin(uRotation),
        sin(uRotation), cos(uRotation)
    );
    uv = rotationMatrix * uv;
    uv += 0.5;

    // ---- shadow --------------------------------------------------
    // Draw a shadow: calculate the distance from the center
    float dist = distance(uv, vec2(0.5, 0.5));
    // If the pixel is inside the shadow radius, we apply a shadow
    vec4 shadowColor = vec4(0);
    if (dist < 0.32) {
        shadowColor = vec4(0,0,0, 0.3);
    }

    // ------------------------------------------------------
    // how many tiles are there in the spritesheet
    float tilesCount = uSpriteCount;
    float tileWidth = tilesCount / uTextureSizeX;
    // Initially transparent color
    vec4 finalColor = vec4(0.0);
    // Calculating the width of one sprite
    float spriteWidth = 1.0 / uSpriteCount;

    // We add margins so that the sprite is not cut off when rotating the texture
    float xPadding = tileWidth * 0.6;
    float yPadding = uTextureSizeY * 0.004;
    float paddedWidth = spriteWidth * (1.0 - xPadding * 2.0);

    // Let's summarize all the sprites
    // we start with the very last sprite, so as not to go through all the sprites
    for (int i = MAX_TILES_COUNT - 1; i >= 0; i--) {
        if (i > tilesCount) {
            continue;
        }
        // if the color of the point has already been taken from some layer,
        // then we interrupt the processing
        if (finalColor.a > 0) {
            break;
        }
        // Defining the left and right borders of the current sprite,
        // taking into account the margins
        float left = i * spriteWidth + spriteWidth * xPadding;
        float right = left + paddedWidth;

        // Texture coordinates of the current sprite
        vec2 spriteUV = uv - vec2(0, 1.5 * yPadding);
        spriteUV.x = i * spriteWidth - xPadding + uv.x * (spriteWidth + 2 * xPadding);
        // we crop all data that goes beyond the current sprite
        if (spriteUV.x <= (i * spriteWidth + 0.001)) {
            continue;
        }
        if (spriteUV.x >= ((i + 1) * spriteWidth)) {
            continue;
        }
        spriteUV.y = (spriteUV.y * (1 + 4 * yPadding));

        if (spriteUV.y <= 0) {
            continue;
        }
        if (spriteUV.y >= 1) {
            continue;
        }

        // we shift the layers of sprites to add volume depending on the angle of rotation
        // This is the basic magic
        spriteUV += vec2(
            i * 0.0006 * sin(uRotation),
            i * 0.016 * cos(uRotation)
        );

        // Getting the color from the current sprite
        vec4 spriteColor = texture(image, spriteUV);

        // Applying the current color
        if (spriteColor.a > 0) {
            finalColor = spriteColor;
        }
    }

    // to color the sprites in a given color, we need to replace the blue color
    // of the original sprite
    if (finalColor.b > finalColor.r && finalColor.b > finalColor.g) {
        // Keeping the brightness (the sum of the RGB components)
        float brightness = finalColor.r + finalColor.g + finalColor.b;
        // Recalculating a new color with the same brightness
        vec3 newColor = overlayColor * brightness;
        finalColor.rgb = newColor;
    }

    if(finalColor.a > 0) {
        fragColor = finalColor;
    } else {
        fragColor = shadowColor;
    }
}

