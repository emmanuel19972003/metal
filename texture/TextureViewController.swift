//
//  TextureViewController.swift
//  tringuloMetal
//
//  Created by Emmanuel Zambrano on 1/03/24.
//

import UIKit
import MetalKit

class TextureViewController: UIViewController {
    
    var device: MTLDevice?
    var model: MTKViewDelegate?
    
    lazy var metalView: MTKView = {
        let view = MTKView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addMTKView()
        setModel()
    }
    
    func addMTKView() {
        
        view.addSubview(metalView)
        
        NSLayoutConstraint.activate([
            metalView.topAnchor.constraint(equalTo: view.topAnchor),
            metalView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            metalView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            metalView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setModel() {
        device = MTLCreateSystemDefaultDevice()
        
        guard let device = device else {
            print("ho hay GPU")
            return
        }
        
        
        metalView.device = device
        
        metalView.colorPixelFormat = .bgra8Unorm_srgb
        metalView.depthStencilPixelFormat = .depth32Float
        
        metalView.clearColor = Colors.green
        
        model = TextureModel(device: device)
        
        metalView.delegate = model
    }

}


