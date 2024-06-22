
// Abberation
#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

[[ stitchable ]]
half4 Ripple(
    float2 position,
    SwiftUI::Layer layer,
    float2 origin,
    float time,
    float amplitude,
    float frequency,
    float decay,
    float speed
) {
    // The distance of the current pixel position from `origin`.
    float distance = length(position - origin);
    // The amount of time it takes for the ripple to arrive at the current pixel position.
    float delay = distance / speed;

    // Adjust for delay, clamp to 0.
    time -= delay;
    time = max(0.0, time);

    // The ripple is a sine wave that Metal scales by an exponential decay function.
    float rippleAmount = amplitude * sin(frequency * time) * exp(-decay * time);

    // A vector of length `amplitude` that points away from position.
    float2 n = normalize(position - origin);

    // Chromatic aberration offsets for RGB channels, scaled by rippleAmount.
    float2 redOffset = float2(0.0, 0.0) * ((rippleAmount) / amplitude);   // Scaled offset for red channel
    float2 greenOffset = float2(0.0, 0.0) * ((rippleAmount) / amplitude); // Scaled offset for green channel
    float2 blueOffset = float2(0.0, 0.0) * ((rippleAmount) / amplitude);  // Scaled offset for blue channel

    // Calculate new positions for each color channel.
    float2 newPositionRed = position + rippleAmount * n + redOffset;
    float2 newPositionGreen = position + rippleAmount * n + greenOffset;
    float2 newPositionBlue = position + rippleAmount * n + blueOffset;

    // Sample the layer at the new positions.
    half4 colorRed = layer.sample(newPositionRed);
    half4 colorGreen = layer.sample(newPositionGreen);
    half4 colorBlue = layer.sample(newPositionBlue);

    // Combine the color channels.
    half4 color;
    color.r = colorRed.r;
    color.g = colorGreen.g;
    color.b = colorBlue.b;
    color.a = (colorRed.a + colorGreen.a + colorBlue.a) / 3.0;

    // Lighten or darken the color based on the ripple amount and its alpha component.
    color.rgb += 0.175 * (rippleAmount / amplitude) * color.a;

    return color;
}
