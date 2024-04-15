//
//  CGRect+edgeMidpoint.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 14/04/2024.
//

import CoreGraphics

extension CGRect {
    func midPoint(along edge: CGRectEdge) -> CGPoint {
        switch edge {
        case .minXEdge: CGPoint(x: minX, y: midY)
        case .minYEdge: CGPoint(x: midX, y: minY)
        case .maxXEdge: CGPoint(x: maxX, y: midY)
        case .maxYEdge: CGPoint(x: midX, y: maxY)
        }
    }
}
