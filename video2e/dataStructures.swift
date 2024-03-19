//
//  dataStructures.swift
//  tringuloMetal
//
//  Created by Emmanuel Zambrano on 13/03/24.
//

import MetalKit

struct MatrixConstants {
    var scale: matrix_float4x4 =  matrix_identity_float4x4
    var rotateX: matrix_float4x4 = matrix_identity_float4x4
    var rotateY: matrix_float4x4 = matrix_identity_float4x4
    var rotateZ: matrix_float4x4 = matrix_identity_float4x4
    var translate: matrix_float4x4 = matrix_identity_float4x4
}

struct ScaleConstants {
    var scale: SIMD3<Float>
    var rotateX:Float
    var rotateY:Float
    var rotateZ:Float
    var translate:SIMD3<Float>
}

extension simd_float4x4 {
    func scaleMatrix(by scaleFactor: SIMD3<Float>) -> simd_float4x4 {
        var result = matrix_identity_float4x4
        let x = scaleFactor.x
        let y = scaleFactor.y
        let z = scaleFactor.z
        
        result.columns = (
            SIMD4<Float>(x, 0, 0, 0),
            SIMD4<Float>(0, y, 0, 0),
            SIMD4<Float>(0, 0, z, 0),
            SIMD4<Float>(0, 0, 0, 1)
        )
        
        
        return matrix_multiply(self, result)
    }
    
    func rotateX(by angel: Float) -> simd_float4x4  {
        let a = cos(angel)
        let b = -sin(angel)
        let c = sin(angel)
        let d = cos(angel)
        var result = matrix_identity_float4x4
        result.columns = (
            SIMD4<Float>(a, 0, b, 0),
            SIMD4<Float>(0, 1, 0, 0),
            SIMD4<Float>(c, 0, d, 0),
            SIMD4<Float>(0, 0, 0, 1)
        )
        return matrix_multiply(self, result.transpose)
    }
    
    func rotateY(by angel: Float) -> simd_float4x4  {
        let a = cos(angel)
        let b = sin(angel)
        let c = -sin(angel)
        let d = cos(angel)
        var result = matrix_identity_float4x4
        result.columns = (
            SIMD4<Float>(a, 0, b, 0),
            SIMD4<Float>(0, 1, 0, 0),
            SIMD4<Float>(c, 0, d, 0),
            SIMD4<Float>(0, 0, 0, 1)
        )
        return matrix_multiply(self, result.transpose)
    }
    
    func rotateZ(by angel: Float) -> simd_float4x4  {
        let a = cos(angel)
        let b = -sin(angel)
        let c = sin(angel)
        let d = cos(angel)
        var result = matrix_identity_float4x4
        result.columns = (
            SIMD4<Float>(a, b, 0, 0),
            SIMD4<Float>(c, d, 0, 0),
            SIMD4<Float>(0, 0, 1, 0),
            SIMD4<Float>(0, 0, 0, 1)
        )
        return matrix_multiply(self, result.transpose)
    }
    
    func translation(by translation: SIMD3<Float>) -> simd_float4x4 {
        var result = matrix_identity_float4x4
        let x = translation.x
        let y = translation.y
        let z = translation.z
        
        result.columns = (
            SIMD4<Float>(1, 0, 0, x),
            SIMD4<Float>(0, 1, 0, y),
            SIMD4<Float>(0, 0, 1, z),
            SIMD4<Float>(0, 0, 0, 1)
        )
        
        
        return matrix_multiply(self, result.transpose)
    }
    
    
}
