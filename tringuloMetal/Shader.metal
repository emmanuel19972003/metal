//
//  Shader.metal
//  tringuloMetal
//
//  Created by Emmanuel Zambrano Quitian on 1/30/24.
//

#include <metal_stdlib>
using namespace metal;

struct Constant {
    float animateBy;
    float animateByY;
};

vertex float4 vertex_shader(const device packed_float3 *vertices [[buffer(0)]],
                            constant Constant &constants [[buffer(1)]],
                            uint vertexId [[vertex_id]]) {
    float4 pos = float4(vertices[vertexId], 1);
    pos.x += constants.animateBy;
    pos.y += constants.animateByY;
    return pos;
//    return float4(vertices[vertexId], 1);
}

fragment half4 fragment_shader(constant Constant &constants [[buffer(0)]]) {
    return half4(constants.animateBy, constants.animateByY, 0, 1); //aparentemente esto es un color en RGBA
}

