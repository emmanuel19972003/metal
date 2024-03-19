//
//  Triangle.swift
//  tringuloMetal
//
//  Created by Emmanuel Zambrano on 13/03/24.
//

import MetalKit

class Triangle: Primitive {
    
    var scaleConstants: ScaleConstants
    
    init(device: MTLDevice, scaleConstants: ScaleConstants) {
        self.scaleConstants = scaleConstants
        super.init(device: device)
        matrixConstants.scale = matrixConstants.scale.scaleMatrix(by: scaleConstants.scale)
        
    }
    
    override func builObject() {

        vertices = [
            Vertex(position: SIMD3<Float>(-0,1,0),
                   color: SIMD4<Float>(1,0,0,1)),
            Vertex(position: SIMD3<Float>(-1,-1,0),
                   color: SIMD4<Float>(0,1,0,1)),
            Vertex(position: SIMD3<Float>(1,-1,0),
                   color: SIMD4<Float>(0,0,1,1))
        ]

        indices = [
            0,1,2
        ]
    }
    
    /*
     
     */
    
    
}
