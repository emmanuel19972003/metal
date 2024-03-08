//
//  Texturable.swift
//  tringuloMetal
//
//  Created by Emmanuel Zambrano on 7/03/24.
//

import Foundation
import Metal
import MetalKit


enum texturebaleFormat: String {
    case jpg
    case png
    case JPG
    case jpge
}

protocol Texturable {
    var texture: MTLTexture? {get set}
}

extension Texturable {
    func setTexture(device: MTLDevice, imageName: String, format: texturebaleFormat = .jpg) -> MTLTexture? {
        let textureLoader = MTKTextureLoader(device: device)
        
        var texture: MTLTexture? = nil
        
        let textureLoaderOptions: [MTKTextureLoader.Option : Any]
        
        
        textureLoaderOptions =
        [MTKTextureLoader.Option.origin : MTKTextureLoader.Origin.bottomLeft]
        
        if let textureURL = Bundle.main.url(forResource: imageName, withExtension: format.rawValue) {
            do {
                texture = try textureLoader.newTexture(URL: textureURL, options: textureLoaderOptions)
            } catch {
                fatalError("llorelo")
            }
        }
        return texture
    }
}
