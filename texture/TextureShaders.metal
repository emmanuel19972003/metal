//
//  TextureShaders.metal
//  tringuloMetal
//
//  Created by Emmanuel Zambrano Quitian on 3/5/24.
//

#include <metal_stdlib>
using namespace metal;

struct VertexInTexture {
    float4 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
};

struct VertexOutTexture {
    float4 position [[ position ]];
    float4 color [[ attribute(1) ]];
};

vertex VertexOutTexture vertex_shader_texture(const VertexInTexture vertexIn [[stage_in]]) {
    VertexOutTexture vertexOut;
    vertexOut.position = vertexIn.position;
    vertexOut.color = vertexIn.color;
    return vertexOut;
    
}

fragment half4 fragment_shader_texture(VertexInTexture vertexIn [[stage_in]]) {
    return half4(vertexIn.color);
}
