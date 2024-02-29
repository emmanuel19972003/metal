//
//  metaStructures.swift
//  tringuloMetal
//
//  Created by Emmanuel Zambrano Quitian on 2/1/24.
//

import Foundation
import Metal
import MetalKit

enum Colors {
    static let green = MTLClearColor(red: 0.0, green: 0.4, blue: 0.21, alpha: 1)
}

struct Constant {
    var animateBy: Float = 0.0
    var animateByY: Float = 0.0
}

struct Vertex {
    var position: SIMD3<Float>
    var color: SIMD4<Float>
}
