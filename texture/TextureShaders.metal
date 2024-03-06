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
    float2 textureCoordinates [[ attribute(2) ]];
};

struct VertexOutTexture {
    float4 position [[ position ]];
    float4 color;
    float2 textureCoordinates;
};

vertex VertexOutTexture vertex_shader_texture(const VertexInTexture vertexIn [[stage_in]]) {
    VertexOutTexture vertexOut;
    vertexOut.position = vertexIn.position;
    vertexOut.color = vertexIn.color;
    vertexOut.textureCoordinates = vertexIn.textureCoordinates;
    return vertexOut;
    
}

fragment half4 texture_fragment(VertexOutTexture vertexIn [[stage_in]],
                                texture2d<float> texture [[texture(0)]]) {
    constexpr sampler defaultSampler;
    float4 color = texture.sample(defaultSampler, vertexIn.textureCoordinates);
    if (color.r > color.g && color.r > color.b) {
        return half4(color.r, color.r, color.r, 1);
    }
    return half4(color.r, color.g, color.b, 1);
    
}
