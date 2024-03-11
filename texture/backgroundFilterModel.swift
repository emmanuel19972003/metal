//
//  backgroundFilterModel.swift
//  tringuloMetal
//
//  Created by Emmanuel Zambrano on 7/03/24.
//

import Foundation
import MetalKit


class backgroundFilterModel: NSObject, Texturable {
    
    var device: MTLDevice
    
    var commandQueue: MTLCommandQueue!
    
    var pipeLineState: MTLRenderPipelineState?
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    var texture: MTLTexture?
    var samplerSate: MTLSamplerState?
    
    var background: MTLTexture?
    
    
    var vertex: [TextureVertex] = [
        TextureVertex(vertex: SIMD3<Float>(-1,1,0), //v0
                      color: SIMD4<Float>(1,0,0,1),
                      texture: SIMD2<Float>(0,1)),
        TextureVertex(vertex:SIMD3<Float>(-1,-1,0), //v1
                      color: SIMD4<Float>(0,1,0,1),
                      texture: SIMD2<Float>(0,0)),
        TextureVertex(vertex: SIMD3<Float>(1,-1,0), //v2
                      color: SIMD4<Float>(0,0,1,1),
                      texture: SIMD2<Float>(1,0)),
        TextureVertex(vertex: SIMD3<Float>(1,1,0), //v3
                      color: SIMD4<Float>(1,0,1,1),
                      texture: SIMD2<Float>(1,1))
        
        
        
    ]
    
    var indices: [UInt16] = [
        0,1,2,
        2,3,0
    ]
    
    init(device: MTLDevice, imageName: String, background: String) {
        self.device = device
        self.commandQueue = device.makeCommandQueue()!
        super.init()
        self.texture = setTexture(device: device, imageName: imageName)
        self.background = setTexture(device: device, imageName: background)
        setBuffers()
        setPipelineState()
        setSampleSampleSate()
    }
    
    private func setSampleSampleSate() {
        let descriptor = MTLSamplerDescriptor()
        descriptor.minFilter = .linear
        descriptor.magFilter = .linear
        samplerSate = device.makeSamplerState(descriptor: descriptor)
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
        let fragmentFunc = lib?.makeFunction(name: "replace_back_ground")
        
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
        
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].offset = MemoryLayout<SIMD3<Float>>.stride + MemoryLayout<SIMD4<Float>>.stride
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

extension backgroundFilterModel: MTKViewDelegate {
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
        
        commandEncoder?.setFragmentTexture(texture, index: 0)
        
        commandEncoder?.setFragmentTexture(background, index: 1)
        
        commandEncoder?.setFragmentSamplerState(samplerSate, index: 0)
        
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

extension backgroundFilterModel {
    func updateBackground(backGround: String, format: texturebaleFormat) {
        background = setTexture(device: device, imageName: backGround, format: format)
    }
}


