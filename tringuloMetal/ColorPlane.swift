//
//  ColorPlane.swift
//  tringuloMetal
//
//  Created by Emmanuel Zambrano Quitian on 2/1/24.
//

import Foundation
import Metal
import MetalKit

class ColorPlane: NSObject {
    
    typealias float3 = SIMD3<Float>
    typealias float4 = SIMD4<Float>
    
    var device: MTLDevice
    var commandQueue: MTLCommandQueue
    
    var pipeLineState: MTLRenderPipelineState?
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    var constants = Constant()
    
    var time: Float = 0.0
    
    var vertices: [Vertex] = [
        Vertex(position: float3(-1,1,0),
               color: float4(1,0,0,1)),
        Vertex(position: float3(-1,-1,0),
               color: float4(0,1,0,1)),
        Vertex(position: float3(1,-1,0),
               color: float4(0,0,1,1)),
        Vertex(position: float3(1,1,0),
               color: float4(1,0,1,1))
    ]
    
    var indices: [UInt16] = [
        0,1,2,
        2,3,0
    ]
    
    init(device: MTLDevice) {
        self.device = device
        self.commandQueue = device.makeCommandQueue()!
        super.init()
        buildModel()
        buildPipeLineState()
    }
    private func buildModel() {
        vertexBuffer = device.makeBuffer(bytes: vertices,
                                         length: vertices.count *
                                         MemoryLayout<Vertex>.stride,
                                         options: [])
        indexBuffer = device.makeBuffer(bytes: indices,
                                         length: indices.count * MemoryLayout<UInt16>.size,
                                         options: [])
        
    }
    
    private func buildPipeLineState() {
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
        vertexDescriptor.attributes[1].offset = MemoryLayout<float3>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        do {
            pipeLineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error as NSError {
            print("error es: \(error.localizedDescription)")
        }
    }
    
}

extension ColorPlane: MTKViewDelegate {
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


