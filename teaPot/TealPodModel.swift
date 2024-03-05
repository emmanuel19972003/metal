//
//  TealPodModel.swift
//  tringuloMetal
//
//  Created by Emmanuel Zambrano on 4/03/24.
//

import Foundation
import Metal
import MetalKit


class TealPodModel: NSObject {
    
    var device: MTLDevice // mi GPU
    var commandQueue: MTLCommandQueue // la commandQueue
    
    var pipeLineState: MTLRenderPipelineState?
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    let vertex: [colorVertex] = [
        colorVertex(position: SIMD3<Float>(0.0, 0.5, 0),
                    color: SIMD4<Float>(1,0,0,1)),
        colorVertex(position: SIMD3<Float>(0.5, -0.5, 0.5),
                    color: SIMD4<Float>(1,0,0,1)),
        colorVertex(position: SIMD3<Float>(-0.5, -0.5, 1),
                    color: SIMD4<Float>(1,1,0,1))
    ]
    
    var indices: [UInt16] = [
        0,1,2
    ]
    
    
    
    init(device: MTLDevice) {
        self.device = device
        self.commandQueue = device.makeCommandQueue()!
        super.init()
        setBuffers()
        buildPipeLineState()
    }
    
    private func setBuffers() {
        
        vertexBuffer = device.makeBuffer(bytes: vertex,
                                         length: vertex.count *
                                         MemoryLayout<colorVertex>.stride,
                                         options: [])
        indexBuffer = device.makeBuffer(bytes: indices,
                                         length: indices.count * MemoryLayout<UInt16>.size,
                                         options: [])
        
    }
    
    private func buildPipeLineState() {
        let lib = device.makeDefaultLibrary()
        let vertexFunc = lib?.makeFunction(name: "vertex_shader_tea_pod")
        let fragmentFunc = lib?.makeFunction(name: "fragment_shader_tea_pod")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunc
        pipelineDescriptor.fragmentFunction = fragmentFunc
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm_srgb
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        
        let vertexDescriptor = MTLVertexDescriptor()
        
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<SIMD3<Float>>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.layouts[0].stride = MemoryLayout<colorVertex>.stride
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        //MARK: - set pipeline
        
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        do {
            pipeLineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error as NSError {
            print("error es: \(error.localizedDescription)")
        }
        
    }
}

extension TealPodModel: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
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
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
    
}

