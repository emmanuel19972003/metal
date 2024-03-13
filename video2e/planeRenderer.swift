//
//  planeRenderer.swift
//  tringuloMetal
//
//  Created by Emmanuel Zambrano on 11/03/24.
//

import MetalKit

class planeRenderer: NSObject {
    
    typealias float3 = SIMD3<Float>
    typealias float4 = SIMD4<Float>
    
    var device: MTLDevice
    var commandQueue: MTLCommandQueue
    
    
    let scene: Scene!
    
    
    init(device: MTLDevice) {
        self.device = device
        self.commandQueue = device.makeCommandQueue()!
        self.scene = Scene(device: device)
        super.init()
    }
    
    
    
}

extension planeRenderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let descriptor = view.currentRenderPassDescriptor
        else { return }
        
        
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder (descriptor: descriptor)
        
        scene.render(commandEncoder: commandEncoder!)

        commitChanges(encoder: commandEncoder, buffer: commandBuffer, drawable: drawable)
    }
    
    private func commitChanges(encoder:  MTLRenderCommandEncoder?, buffer: MTLCommandBuffer?, drawable: CAMetalDrawable) {
        encoder?.endEncoding()
        buffer?.present(drawable)
        buffer?.commit()
    }
}


