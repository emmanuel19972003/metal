//
//  Node.swift
//  tringuloMetal
//
//  Created by Emmanuel Zambrano on 11/03/24.
//

import MetalKit

class Node {//esto podría ser un protocolo
    
    
    var children: [Node] = []
    
    func addChil(child: Node) {
        children.append(child)
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder) {
        for child in children {
            child.render(commandEncoder: commandEncoder)
        }
    }
}
