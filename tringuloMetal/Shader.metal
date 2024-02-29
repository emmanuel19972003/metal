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
    return half4(0.5 * constants.animateByY , 0, 0, 1); //aparentemente esto es un color en RGBA
}

fragment half4 fragment_shader_Sub(constant Constant &constants [[buffer(0)]]) {
    float red = 1;
    if (constants.animateByY  <= -0.9) {
        red = 1;
    } else {
        red = 0;
    }
    
    return half4(red, 0, 0, 1); //aparentemente esto es un color en RGBA
}


// MARK: Shaders for plane file

struct VertexIn {
    float4 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
};

struct VertexOut {
    float4 position [[ position ]];
    float4 color [[ attribute(1) ]];
};

vertex VertexOut vertex_shader_plane(const VertexIn vertexIn [[stage_in]]) {
    VertexOut vertexOut;
    vertexOut.position = vertexIn.position;
    vertexOut.color = vertexIn.color;
    return vertexOut;
    
}

fragment half4 fragment_shader_plane(VertexOut vertexin [[stage_in]] ) {
    return half4(vertexin.color); //aparentemente esto es un color en RGBA
}


