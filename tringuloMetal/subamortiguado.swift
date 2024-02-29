//
//  subamortiguado.swift
//  tringuloMetal
//
//  Created by Emmanuel Zambrano Quitian on 2/1/24.
//

import Foundation
import Metal
import MetalKit

class subamortiguado: NSObject {
    var device: MTLDevice
    var commandQueue: MTLCommandQueue
    
    var pipeLineState: MTLRenderPipelineState?
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    var constants = Constant()
    
    var time: Float = 0.0
    
    var vertices: [Float] = [
        -0.9,0.1,0,
        -1,0,0,
        -0.8,0,0
    ]
    
    var indices: [UInt16] = [
        0, 1, 2
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
                                         length: vertices.count * MemoryLayout<Float>.size,
                                         options: [])
        
        indexBuffer = device.makeBuffer(bytes: indices,
                                         length: indices.count * MemoryLayout<UInt16>.size,
                                         options: [])
    }
    
    private func buildPipeLineState() {
        let lib = device.makeDefaultLibrary()
        let vertexFunc = lib?.makeFunction(name: "vertex_shader")
        let fragmentFunc = lib?.makeFunction(name: "fragment_shader_Sub")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunc
        pipelineDescriptor.fragmentFunction = fragmentFunc
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm_srgb
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        
        do {
            pipeLineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error as NSError {
            print("error es: \(error.localizedDescription)")
        }
    }
    
}

extension subamortiguado: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let pipeLineState = pipeLineState,
              let indexBuffer = indexBuffer,
              let descriptor = view.currentRenderPassDescriptor
        else { return }
        
        animate(view: view)
        
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder (descriptor: descriptor)
        
        commandEncoder?.setRenderPipelineState(pipeLineState)
        
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        commandEncoder?.setVertexBytes(&constants,
                                       length: MemoryLayout<Constant>.stride,
                                       index: 1)
        
        commandEncoder?.setFragmentBytes(&constants,
                                         length: MemoryLayout<Constant>.stride,
                                         index: 0)

        commandEncoder?.drawIndexedPrimitives(type: .triangle,
                                              indexCount: indices.count,
                                              indexType: .uint16,
                                              indexBuffer: indexBuffer,
                                              indexBufferOffset: 0)
        

        commitChanges(encoder: commandEncoder, buffer: commandBuffer, drawable: drawable)
    }
    
    func animate(view: MTKView) {
        time += 1 / Float(view.preferredFramesPerSecond) //constant
        let e: Float =  2.7182818284
        constants.animateBy = time
        
        constants.animateByY = abs(2 * pow(e, -2.5 * time) * sin(9.75 * time + 1.5)) - 1
        time = time >= 2 ? 0 : time
    }
    
    private func commitChanges(encoder:  MTLRenderCommandEncoder?, buffer: MTLCommandBuffer?, drawable: CAMetalDrawable) {
        encoder?.endEncoding()
        buffer?.present(drawable)
        buffer?.commit()
    }
}

