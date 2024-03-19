//
//  Scene.swift
//  tringuloMetal
//
//  Created by Emmanuel Zambrano on 11/03/24.
//

import MetalKit

class Scene: Node {
    let device: MTLDevice
    init(device: MTLDevice) {
        self.device = device
        super.init()
        self.addChil(child: Triangle(device: device, scaleConstants:
                                        ScaleConstants(scale: SIMD3<Float>(0.5),
                                                       rotateX: 0,
                                                       rotateY: 0,
                                                       rotateZ: 0,
                                                       translate: SIMD3<Float>(0))))
        
    }
}
