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
    
    lazy var butonBackGround: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("cahgen chavground", for: .normal)
        view.addTarget(self, action: #selector(buttonTaped), for: .touchUpInside)
        view.backgroundColor = .white
        view.setTitleColor(.black, for: .normal)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addMTKView()
        addButton()
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
    
    private func addButton() {
        view.addSubview(butonBackGround)
        NSLayoutConstraint.activate([
            butonBackGround.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            butonBackGround.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            butonBackGround.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            butonBackGround.heightAnchor.constraint(equalToConstant: 20)
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
        
        model = backgroundFilterModel(device: device, imageName: "greenScreen", background: "ladScape")
        
        metalView.delegate = model
    }
    
    @objc func buttonTaped() {
        guard let model = model as? backgroundFilterModel else {
             return
        }
        
        let random = Int.random(in: 0...2)
        let backgrounds = ["ladScape", "color", "Beautiful_landscape", "pexels-james-wheeler-417074"]
        let formats: [texturebaleFormat] = [.jpg, .jpg, .JPG, .jpg]
        
        model.updateBackground(backGround: backgrounds[random], format: formats[random])
    }

}


