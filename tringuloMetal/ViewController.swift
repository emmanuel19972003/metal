//
//  ViewController.swift
//  tringuloMetal
//
//  Created by Emmanuel Zambrano Quitian on 1/28/24.
//

import UIKit
import MetalKit

enum Colors {
    static let green = MTLClearColor(red: 0.0, green: 0.4, blue: 0.21, alpha: 1)
}

struct Constant {
    var animateBy: Float = 0.0
    var animateByY: Float = 0.0
}

class ViewController: UIViewController {
    
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    
    var constants = Constant()
    
    var time: Float = 0.0
    
    var vertices: [Float] = [
        -0.5,0.5,0,
         0,-0.5,0,
         0.5,0.5,0
    ]
    
    var indices: [UInt16] = [
        0, 1, 2
    ]
    
    var pipeLineState: MTLRenderPipelineState?
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    var vertexBuffer2: MTLBuffer?
    
    
    @IBOutlet weak var metalView: MTKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        metalView.colorPixelFormat = .bgra8Unorm_srgb
        setUpMetal()
        metalView.delegate = self
        buildModel()
        buildPipeLineState()
    }
    
    func setUpMetal() {
        metalView.device = MTLCreateSystemDefaultDevice() //access to CPu
        device = metalView.device
        
        metalView.clearColor = Colors.green
        commandQueue = device.makeCommandQueue() // assigning
        
    }
    
    private func buildModel() {
        vertexBuffer = device.makeBuffer(bytes: vertices,
                                         length: vertices.count * MemoryLayout<Float>.size,
                                         options: [])
        
        vertexBuffer2 = device.makeBuffer(bytes: vertices,
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
    
    private func buildPipeLineState2() {
        let lib = device.makeDefaultLibrary()
        let vertexFunc = lib?.makeFunction(name: "vertex_shader2")
        let fragmentFunc = lib?.makeFunction(name: "fragment_shader2")
        
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

extension ViewController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let pipeLineState = pipeLineState,
              let indexBuffer = indexBuffer,
              let descriptor = view.currentRenderPassDescriptor
        else { return }
        
        time += 1 / Float(view.preferredFramesPerSecond) //constant
        constants.animateBy = (sin(time)/2)
        constants.animateByY = (cos(time)/2)
        
        
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

