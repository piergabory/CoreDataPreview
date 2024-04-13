//
//  Range+CustomStringConvertible.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 11/04/2024.
//

import Foundation

extension PartialRangeFrom: CustomStringConvertible where Bound: Numeric {
    public var description: String {
        String(describing: lowerBound) + "...∞"
    }
}

extension PartialRangeThrough: CustomStringConvertible where Bound: UnsignedInteger {
    public var description: String {
        "0..." + String(describing: upperBound)
    }
}

extension PartialRangeUpTo: CustomStringConvertible where Bound: UnsignedInteger {
    public var description: String {
        "0..<" + String(describing: upperBound)
    }
}
