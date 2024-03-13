//
//  Plane.swift
//  tringuloMetal
//
//  Created by Emmanuel Zambrano on 11/03/24.
// this is a model

import MetalKit

class Plane: Primitive {
    
    var scale: Float = 1.0
    
    override func builObject() {
        vertices = [
            Vertex(position: SIMD3<Float>(-scale,scale,0),
                   color: SIMD4<Float>(1,0,0,1)),
            Vertex(position: SIMD3<Float>(-scale,-scale,0),
                   color: SIMD4<Float>(0,1,0,1)),
            Vertex(position: SIMD3<Float>(scale,-scale,0),
                   color: SIMD4<Float>(0,0,1,1)),
            Vertex(position: SIMD3<Float>(scale,scale,0),
                   color: SIMD4<Float>(1,0,1,1))
        ]
        indices = [
            0,1,2,
            2,3,0
        ]
    }
    
    
}
