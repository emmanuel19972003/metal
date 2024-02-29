//
//  tiroParabolico.swift
//  tringuloMetal
//
//  Created by Emmanuel Zambrano Quitian on 2/1/24.
//

import UIKit
import MetalKit

class tiroParabolico: NSObject{
    
    var constants = Constant()
    
    var time: Float = 0.0
    
    var device: MTLDevice
    var commandQueue: MTLCommandQueue
    
    var pipeLineState: MTLRenderPipelineState?
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    var vertices: [Float] = [
        -1,-1,0,
         -0.95,-0.9,0,
         -0.9,-1,0
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
        let fragmentFunc = lib?.makeFunction(name: "fragment_shader")
        
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

extension tiroParabolico: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let pipeLineState = pipeLineState,
              let indexBuffer = indexBuffer,
              let descriptor = view.currentRenderPassDescriptor
        else { return }
        let tiempoDeCaida: Float = 2.0
        let angle: Float = sqrt(2)/2
        let velocidad: Float = 2 / (tiempoDeCaida * cos(angle))
        
        time += 1 / Float(view.preferredFramesPerSecond) //constant
        constants.animateBy = velocidad * time * cos(angle)
        constants.animateByY = (2 - 4) * time * time + 4*time
        print(constants.animateByY)
        time = time > tiempoDeCaida ? 0 : time
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder (descriptor: descriptor)
        
        commandEncoder?.setRenderPipelineState(pipeLineState)
        
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
//        commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        
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
        

        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}


