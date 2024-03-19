//
//  GameControllerViewController.swift
//  tringuloMetal
//
//  Created by Emmanuel Zambrano on 19/03/24.
//

import MetalKit
import UIKit

class GameControllerViewController: UIViewController {
    
    var device: MTLDevice?
    var model: MTKViewDelegate?
    
    lazy var metalView: MTKView = {
        let view = MTKView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setTitle("R", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(rightButtonTaped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var upButton: UIButton = {
        let button = UIButton()
        button.setTitle("U", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(upButtonTaped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var leftButton: UIButton = {
        let button = UIButton()
        button.setTitle("L", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(leftButtonTaped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var downButton: UIButton = {
        let button = UIButton()
        button.setTitle("D", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(downButtonTaped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var clockWiseRotationButton: UIButton = {
        let button = UIButton()
        button.setTitle("CW", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(clockWiseRotationButtonTaped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var zRotationButton: UIButton = {
        let button = UIButton()
        button.setTitle("ACW", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(zRotationButtonTaped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var stackOne: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var stackTwo : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    
    @objc func rightButtonTaped() {
        guard let model = model as? planeRenderer else {return}
        for child in model.scene.children {
            guard let base = child as? Triangle else {return}
            base.translate(by: SIMD3<Float>(0.1,0,0))
        }
    }
    
    @objc func upButtonTaped() {
        guard let model = model as? planeRenderer else {return}
        for child in model.scene.children {
            guard let base = child as? Triangle else {return}
            base.translate(by: SIMD3<Float>(0,0.1,0))
        }
    }
    
    @objc func leftButtonTaped() {
        guard let model = model as? planeRenderer else {return}
        for child in model.scene.children {
            guard let base = child as? Triangle else {return}
            base.translate(by: SIMD3<Float>(-0.1,0,0))
        }
    }
    
    @objc func downButtonTaped() {
        guard let model = model as? planeRenderer else {return}
        for child in model.scene.children {
            guard let base = child as? Triangle else {return}
            base.translate(by: SIMD3<Float>(0,-0.1,0))
        }
    }
    
    @objc func clockWiseRotationButtonTaped() {
        guard let model = model as? planeRenderer else {return}
        for child in model.scene.children {
            guard let base = child as? Triangle else {return}
            base.RoteZ(by: 1)
        }
    }
    
    @objc func zRotationButtonTaped() {
        guard let model = model as? planeRenderer else {return}
        for child in model.scene.children {
            guard let base = child as? Triangle else {return}
            base.RoteZAC(by: 1)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addMTKView()
        setModel()
        setStackView()
    }
    
    func setStackView() {
        view.addSubview(stackOne)
        view.addSubview(stackTwo)
        
        NSLayoutConstraint.activate([
            stackOne.heightAnchor.constraint(equalToConstant: 30),
            stackOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            stackOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            stackOne.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        
        NSLayoutConstraint.activate([
            stackTwo.heightAnchor.constraint(equalToConstant: 30),
            stackTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            stackTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            stackTwo.bottomAnchor.constraint(equalTo: stackOne.topAnchor, constant: -10)
        ])
        
        stackOne.addArrangedSubview(clockWiseRotationButton)
        stackOne.addArrangedSubview(zRotationButton)
        
        stackTwo.addArrangedSubview(rightButton)
        stackTwo.addArrangedSubview(upButton)
        stackTwo.addArrangedSubview(leftButton)
        stackTwo.addArrangedSubview(downButton)
        
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
        
        model = planeRenderer(device: device)
        
        metalView.delegate = model
    }
}




