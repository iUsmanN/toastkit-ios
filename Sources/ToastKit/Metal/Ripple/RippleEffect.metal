
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

// Saturation (Circle)
//#include <metal_stdlib>
//#include <SwiftUI/SwiftUI.h>
//using namespace metal;
//
//[[ stitchable ]]
//half4 Ripple(
//    float2 position,
//    SwiftUI::Layer layer,
//    float2 origin,
//    float time,
//    float amplitude,
//    float frequency,
//    float decay,
//    float speed
//) {
//    // The Manhattan distance of the current pixel position from `origin`.
//    float distance = abs(position.x - origin.x) + abs(position.y - origin.y);
//
//    // The amount of time it takes for the ripple to arrive at the current pixel position.
//    float delay = distance / speed;
//
//    // Adjust for delay, clamp to 0.
//    time -= delay;
//    time = max(0.0, time);
//
//    // The ripple is a sine wave that Metal scales by an exponential decay function.
//    float rippleAmount = amplitude * sin(frequency * time) * exp(-decay * time);
//
//    // Chromatic aberration offsets for RGB channels, scaled by rippleAmount.
//    float2 redOffset = float2(0.003, 0.003) * (rippleAmount / amplitude);  // Scaled offset for red channel
//    float2 greenOffset = float2(0.0, 0.0);  // No offset for green channel
//    float2 blueOffset = float2(-0.003, -0.003) * (rippleAmount / amplitude);  // Scaled offset for blue channel
//
//    // Calculate new positions for each color channel.
//    float2 newPositionRed = position + rippleAmount * normalize(position - origin) + redOffset;
//    float2 newPositionGreen = position + rippleAmount * normalize(position - origin) + greenOffset;
//    float2 newPositionBlue = position + rippleAmount * normalize(position - origin) + blueOffset;
//
//    // Sample the layer at the new positions.
//    half4 colorRed = layer.sample(newPositionRed);
//    half4 colorGreen = layer.sample(newPositionGreen);
//    half4 colorBlue = layer.sample(newPositionBlue);
//
//    // Combine the color channels.
//    half4 color;
//    color.r = colorRed.r;
//    color.g = colorGreen.g;
//    color.b = colorBlue.b;
//    color.a = (colorRed.a + colorGreen.a + colorBlue.a) / 3.0;
//
//    // Lighten or darken the color based on the ripple amount and its alpha component.
//    color.rgb += 0.1 * (rippleAmount / amplitude) * color.a;
//
//    // Convert color to grayscale based on the ripple amount.
//    float grayValue = dot(color.rgb, half3(0.299, 0.587, 0.114));
//        half3 gray = half3(grayValue, grayValue, grayValue);
//        color.rgb = mix(color.rgb, gray, rippleAmount / amplitude);
//
//        return color;
//    }

// Saturation V-shaped
//#include <metal_stdlib>
//#include <SwiftUI/SwiftUI.h>
//using namespace metal;
//
//[[ stitchable ]]
//half4 Ripple(
//    float2 position,
//    SwiftUI::Layer layer,
//    float2 origin,
//    float time,
//    float amplitude,
//    float frequency,
//    float decay,
//    float speed
//) {
//    // The Manhattan distance of the current pixel position from `origin`.
//    float distance = abs(position.x - origin.x) + abs(position.y - origin.y);
//
//    // The amount of time it takes for the ripple to arrive at the current pixel position.
//    float delay = distance / speed;
//
//    // Adjust for delay, clamp to 0.
//    time -= delay;
//    time = max(0.0, time);
//
//    // The ripple is a sine wave that Metal scales by an exponential decay function.
//    float rippleAmount = amplitude * sin(frequency * time) * exp(-decay * time);
//
//    // Calculate the new position.
//    float2 newPosition = position + rippleAmount * normalize(position - origin);
//
//    // Sample the layer at the new position.
//    half4 color = layer.sample(newPosition);
//
//    // Lighten or darken the color based on the ripple amount and its alpha component.
//    color.rgb += 0.1 * (rippleAmount / amplitude) * color.a;
//
//    // Remove saturation based on ripple amount.
//    float desaturationAmount = rippleAmount / amplitude;
//    half3 gray = half3(dot(color.rgb, half3(0.299, 0.587, 0.114)));
//    color.rgb = mix(color.rgb, gray, desaturationAmount);
//
//    return color;
//}
