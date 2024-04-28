//
//  ClosestEdgeConnectionStrategy.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 14/04/2024.
//

import SwiftUI

struct ClosestEdgeConnectionStrategy: BoxConnectionStrategy {
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

