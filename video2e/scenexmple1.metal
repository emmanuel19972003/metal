//
//  scenexmple1.metal
//  tringuloMetal
//
//  Created by Emmanuel Zambrano on 11/03/24.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
};

struct VertexOut {
    float4 position [[ position ]];
    float4 color [[ attribute(1) ]];
};

struct MatrixConstans {
    float4x4 scale;
    float4x4 rotateX;
    float4x4 rotateY;
    float4x4 rotateZ;
    float4x4 translate;
};

vertex VertexOut vertex_primitive (const VertexIn vertexIn [[stage_in]],
                                   constant MatrixConstans &constants [[buffer(1)]]) {
    VertexOut vertexOut;
    vertexOut.position = constants.rotateX *
                         constants.rotateY *
                         constants.rotateZ *
                         constants.translate *
                         constants.scale * vertexIn.position;
//    vertexOut.position = constants.rotateX * vertexIn.position;
//    vertexOut.position = constants.rotateY * vertexIn.position;
//    vertexOut.position = constants.rotateZ * vertexIn.position;
    vertexOut.color = vertexIn.color;
    return vertexOut;
    
}

fragment half4 fragment_primitive(VertexOut vertexin [[stage_in]] ) {
    return half4(vertexin.color); //aparentemente esto es un color en RGBA
}

