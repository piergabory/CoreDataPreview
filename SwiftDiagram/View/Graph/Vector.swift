//
//  Vector.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 14/04/2024.
//

import SwiftUI

struct Vector: VectorArithmetic {
    var x: CGFloat
    var y: CGFloat

    static let zero = Vector(x: 0, y: 0)

    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }

    init(_ point: CGPoint) {
        self.x = point.x
        self.y = point.y
    }

    init(_ size: CGSize) {
        self.x = size.width
        self.y = size.height
    }

    var magnitudeSquared: Double {
        x * x + y * y
    }

    mutating func scale(by factor: Double) {
        x *= factor
        y *= factor
    }

    static func + (lhs: Vector, rhs: Vector) -> Vector {
        Vector(x: lhs.x + rhs.x, y: rhs.y + rhs.y)
    }

    static func - (lhs: Vector, rhs: Vector) -> Vector {
        Vector(x: lhs.x - rhs.x, y: rhs.y - rhs.y)
    }
}

extension CGPoint {
    init(_ vector: Vector) {
        self.init(x: vector.x, y: vector.y)
    }
}

extension CGSize {
    init(_ vector: Vector) {
        self.init(width: vector.x, height: vector.y)
    }
}
