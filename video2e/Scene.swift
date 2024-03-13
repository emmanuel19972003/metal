//
//  Scene.swift
//  tringuloMetal
//
//  Created by Emmanuel Zambrano on 11/03/24.
//

import MetalKit

class Scene: Node {
    init(device: MTLDevice) {
        super.init()
        self.addChil(child: Plane(device: device))
        self.addChil(child: Triangle(device: device))
        
    }
}
