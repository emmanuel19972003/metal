//
//  TextureModel.swift
//  tringuloMetal
//
//  Created by Emmanuel Zambrano Quitian on 3/5/24.
//

import Foundation
import Metal
import MetalKit

struct TextureVertex {
    let vertex: SIMD3<Float>
    let color: SIMD4<Float>
    let texture: SIMD2<Float>
}

class TextureModel: NSObject {
    
    var device: MTLDevice
    
    var commandQueue: MTLCommandQueue!
    
    var pipeLineState: MTLRenderPipelineState?
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    
    var vertex: [TextureVertex] = [
        TextureVertex(vertex: SIMD3<Float>(-1,1,0),
                      color: SIMD4<Float>(1,0,0,1),
                      texture: SIMD2<Float>(0,1)),
        TextureVertex(vertex:SIMD3<Float>(-1,-1,0),
                      color: SIMD4<Float>(0,1,0,1),
                      texture: SIMD2<Float>(0,0)),
        TextureVertex(vertex: SIMD3<Float>(1,-1,0),
                      color: SIMD4<Float>(0,0,1,1),
                      texture: SIMD2<Float>(1,1)),
        TextureVertex(vertex: SIMD3<Float>(1,1,0),
                      color: SIMD4<Float>(1,0,1,1),
                      texture: SIMD2<Float>(1,0))
        
        
        
    ]
    
    var indices: [UInt16] = [
        0,1,2,
        2,3,0
    ]
    
    init(device: MTLDevice) {
        self.device = device
        self.commandQueue = device.makeCommandQueue()!
        super.init()
        setBuffers()
        setPipelineState()
    }
    
    private func setBuffers() {
        vertexBuffer = device.makeBuffer(bytes: vertex,
                                         length: vertex.count * MemoryLayout<TextureVertex>.stride,
                                         options: [])
        
        indexBuffer = device.makeBuffer(bytes: indices,
                                        length: indices.count * MemoryLayout<UInt16>.stride,
                                        options: [])
    }
    
    private func setPipelineState() { // hago las libs y el memory Map
        
        let lib = device.makeDefaultLibrary()
        let vertexFunc = lib?.makeFunction(name: "vertex_shader_texture")
        let fragmentFunc = lib?.makeFunction(name: "fragment_shader_texture")
        
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
        vertexDescriptor.attributes[1].offset = MemoryLayout<float3>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].offset = MemoryLayout<float3>.stride + MemoryLayout<float4>.stride
        vertexDescriptor.attributes[2].bufferIndex = 0
        
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<TextureVertex>.stride
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        do {
            pipeLineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error as NSError {
            print("error es: \(error.localizedDescription)")
        }
        
        
    }
    
    
}

extension TextureModel: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let pipeLineState = pipeLineState,
              let indexBuffer = indexBuffer,
              let descriptor = view.currentRenderPassDescriptor
        else { return }
        
        
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder (descriptor: descriptor)
        
        commandEncoder?.setRenderPipelineState(pipeLineState)
        
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        commandEncoder?.drawIndexedPrimitives(type: .triangle,
                                              indexCount: indices.count,
                                              indexType: .uint16,
                                              indexBuffer: indexBuffer,
                                              indexBufferOffset: 0)
        
        commitChanges(encoder: commandEncoder, buffer: commandBuffer, drawable: drawable)
    }
    
    private func commitChanges(encoder:  MTLRenderCommandEncoder?, buffer: MTLCommandBuffer?, drawable: CAMetalDrawable) {
        encoder?.endEncoding()
        buffer?.present(drawable)
        buffer?.commit()
    }
}


