//
//  Primitive.swift
//  tringuloMetal
//
//  Created by Emmanuel Zambrano on 11/03/24.
//

import MetalKit

class Primitive: Node {
    
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    var vertices: [Vertex]!
    var indices: [UInt16]!
    
    var pipeLineState: MTLRenderPipelineState?
    
    init(device: MTLDevice) {
        super.init()
        self.builObject()
        self.buildPipeLineState(device: device
        )
        self.buildModel(device: device)
    }
    
    func builObject() {}
    
    func buildModel(device: MTLDevice) {
        vertexBuffer = device.makeBuffer(bytes: vertices,
                                         length: vertices.count *
                                         MemoryLayout<Vertex>.stride,
                                         options: [])
        indexBuffer = device.makeBuffer(bytes: indices,
                                        length: indices.count * MemoryLayout<UInt16>.size,
                                        options: [])
        
    }
    
    func buildPipeLineState(device: MTLDevice) {
        let lib = device.makeDefaultLibrary()
        let vertexFunc = lib?.makeFunction(name: "vertex_shader_plane")
        let fragmentFunc = lib?.makeFunction(name: "fragment_shader_plane")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunc
        pipelineDescriptor.fragmentFunction = fragmentFunc
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm_srgb
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        
        let vertexDescriptor = MTLVertexDescriptor()
        
        //lo de ponerle color y eso a los vertices
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<SIMD3<Float>>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        do {
            pipeLineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error as NSError {
            print("error es: \(error.localizedDescription)")
        }
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder?) {
        guard let commandEncoder = commandEncoder,
              let pipeLineState = pipeLineState else { return }
        commandEncoder.setRenderPipelineState(pipeLineState)
        super.render(commandEncoder: commandEncoder)
        guard let indexBuffer = indexBuffer else { return }
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                              indexCount: indices.count,
                                              indexType: .uint16,
                                              indexBuffer: indexBuffer,
                                              indexBufferOffset: 0)

    }
    
    func rotateX(degrees: Float) {
        
    }
    
    func rotateY(degrees: Float) {
        
    }
    
    func rotateZ(degrees: Float) {
        
    }
    
    func moveX(_ x: Float) {
        
    }
    
    func moveY(_ x: Float) {
        
    }
    
    func moveZ(_ x: Float) {
        
    }
    
}
