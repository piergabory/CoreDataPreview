//
//  ControlPointSelector.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 14/04/2024.
//

import SwiftUI

protocol BoxConnectionStrategy {
    typealias EdgePair = (origin: CGRectEdge, destination: CGRectEdge)
    func boxConnection(from origin: CGRect, to destination: CGRect) -> EdgePair
}

/// Will find the best two vertical edges for tracing a connection
struct VerticalFacingEdges: BoxConnectionStrategy {
    func boxConnection(from origin: CGRect, to destination: CGRect) -> EdgePair {
        if origin.maxX < destination.minX {
            (.maxXEdge, .minXEdge)
        } else if origin.minX > destination.maxX {
            (.minXEdge, .maxXEdge)
        } else if abs(destination.minX - origin.minX) < abs(destination.maxX - origin.maxX)  {
            (.minXEdge, .minXEdge)
        } else {
            (.maxXEdge, .maxXEdge)
        }
    }
}

/// Will find the best two horizontal edges for tracing a connection
struct HorizontalFacingEdges: BoxConnectionStrategy {
    func boxConnection(from origin: CGRect, to destination: CGRect) -> EdgePair {
        if origin.maxY < destination.minY {
            (.maxYEdge, .minYEdge)
        } else if origin.minY > destination.maxY {
            (.minYEdge, .maxYEdge)
        } else if abs(destination.minY - origin.minY) < abs(destination.maxY - origin.maxY)  {
            (.minYEdge, .minYEdge)
        } else {
            (.maxYEdge, .maxYEdge)
        }
    }
}

struct ClosestEdge: BoxConnectionStrategy {
    func boxConnection(from origin: CGRect, to destination: CGRect) -> EdgePair {
        let edges: [CGRectEdge] = [.maxXEdge, .maxYEdge, .minXEdge, .minYEdge]
        var minDistanceSquared: CGFloat = .infinity
        var bestResult: EdgePair = (.maxXEdge, .minXEdge)
        for originEdge in edges {
            let originPoint = origin.midPoint(along: originEdge)
            for destinationEdge in edges {
                let destinationPoint = destination.midPoint(along: destinationEdge)
                let Δx = destinationPoint.x - originPoint.x
                let Δy = destinationPoint.y - originPoint.y
                let distanceSquared = Δx * Δx + Δy * Δy
                if distanceSquared < minDistanceSquared {
                    minDistanceSquared = distanceSquared
                    bestResult = (originEdge, destinationEdge)
                }
            }
        }
        return bestResult
    }
}

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
