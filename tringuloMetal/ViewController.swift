//
//  ViewController.swift
//  tringuloMetal
//
//  Created by Emmanuel Zambrano Quitian on 1/28/24.
//

import UIKit
import MetalKit

class ViewController: UIViewController {
    
    let device = MTLCreateSystemDefaultDevice()
    var model: MTKViewDelegate?
    
    @IBOutlet weak var metalView: MTKView!
    
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        metalView.colorPixelFormat = .bgra8Unorm_srgb
        setUpMetal()
        segmentControl.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
    }
    
    func setUpMetal() {
        metalView.device = device //access to CPu
        metalView.clearColor = Colors.green
        
        model = trianguloCruculos(device: device!)
        metalView.delegate = model
        
    }
    
    @objc func segmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            model = trianguloCruculos(device: device!)
            metalView.delegate = model
        case 1:
            model = tiroParabolico(device: device!)
            metalView.delegate = model
        case 2:
            model = subamortiguado(device: device!)
            metalView.delegate = model
        case 3:
            model = ColorPlane(device: device!)
            metalView.delegate = model
        default:
            model = subamortiguado(device: device!)
            metalView.delegate = model
        }
    }
}



