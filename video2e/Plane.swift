//
//  Plane.swift
//  tringuloMetal
//
//  Created by Emmanuel Zambrano on 11/03/24.
// this is a model

import MetalKit

class Plane: Node {
    
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    
     
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    init(device: MTLDevice, commandQueue: MTLCommandQueue) {
        self.device = device
        self.commandQueue = commandQueue
    }
    
    var vertices: [Vertex] = [
        Vertex(position: SIMD3<Float>(-1,1,0),
               color: SIMD4<Float>(1,0,0,1)),
        Vertex(position: SIMD3<Float>(-1,-1,0),
               color: SIMD4<Float>(0,1,0,1)),
        Vertex(position: SIMD3<Float>(1,-1,0),
               color: SIMD4<Float>(0,0,1,1)),
        Vertex(position: SIMD3<Float>(1,1,0),
               color: SIMD4<Float>(1,0,1,1))
    ]
    
    var indices: [UInt16] = [
        0,1,2,
        2,3,0
    ]
    
    func buildModel() {
        vertexBuffer = device.makeBuffer(bytes: vertices,
                                         length: vertices.count *
                                         MemoryLayout<Vertex>.stride,
                                         options: [])
        indexBuffer = device.makeBuffer(bytes: indices,
                                         length: indices.count * MemoryLayout<UInt16>.size,
                                         options: [])
        
    }
}
