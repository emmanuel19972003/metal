//
//  teaPod.metal
//  tringuloMetal
//
//  Created by Emmanuel Zambrano on 5/03/24.
//

#include <metal_stdlib>
using namespace metal;

struct VertexInTeaPod {
    float4 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
};

struct VertexOutTeaPod {
    float4 position [[ position ]];
    float4 color [[ attribute(1) ]];
};

vertex VertexOutTeaPod vertex_shader_tea_pod(const VertexInTeaPod vertexIn [[stage_in]]) {
    VertexOutTeaPod vertexOut;
    vertexOut.position = vertexIn.position;
    vertexOut.color = vertexIn.color;
    return vertexOut;
    
}

fragment half4 fragment_shader_tea_pod(VertexOutTeaPod vertexIn [[stage_in]] ) {
    float z_value = vertexIn.position.z;
    return half4(vertexIn.color * (z_value)); //aparentemente esto es un color en RGBA
}

