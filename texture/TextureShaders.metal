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
    float greenColor = float(230)/255;
    if (color.g > greenColor) {
        return half4(vertexIn.color);
    }
    return half4(color.r, color.g, color.b, 1);
    
}

fragment half4 replace_back_ground(VertexOutTexture vertexIn [[stage_in]],
                                texture2d<float> texture [[texture(0)]],
                                   texture2d<float> texture2 [[texture(1)]],
                                   sampler sampler2d [[sampler(0)]]) {
//    constexpr sampler defaultSampler;
//    float4 color = texture.sample(defaultSampler, vertexIn.textureCoordinates);
//    float4 backGroundColor = texture2.sample(defaultSampler, vertexIn.textureCoordinates);
    float4 color = texture.sample(sampler2d, vertexIn.textureCoordinates);
    float4 backGroundColor = texture2.sample(sampler2d, vertexIn.textureCoordinates);
    float greenColor = float(230)/255;
    if (color.g > greenColor) {
        return half4(backGroundColor.r, backGroundColor.g, backGroundColor.b, 1);
    }
    return half4(color.r, color.g, color.b, 1);
    
}
