//
//  Node.swift
//  tringuloMetal
//
//  Created by Emmanuel Zambrano on 11/03/24.
//

import MetalKit

class Node {
    var children: [Node] = []
    
    func addChil(child: Node) {
        children.append(child)
    }
}
