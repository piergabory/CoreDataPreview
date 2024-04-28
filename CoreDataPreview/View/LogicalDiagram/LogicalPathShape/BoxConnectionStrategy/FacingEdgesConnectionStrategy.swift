//
//  FacingEdgesConnectionStrategy.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 14/04/2024.
//

import Foundation

/// Will find the best two facing edges for tracing a connection
struct FacingEdgesConnectionStrategy: BoxConnectionStrategy {
    enum Orientation { case horizontal, vertical }
    
    let edgeOrientation: Orientation

    init(edgeOrientation: Orientation = .vertical) {
        self.edgeOrientation = edgeOrientation
    }

    func boxConnection(from origin: CGRect, to destination: CGRect) -> EdgePair {
        switch edgeOrientation {
        case .horizontal:
            if origin.maxY < destination.minY {
                (.maxYEdge, .minYEdge)
            } else if origin.minY > destination.maxY {
                (.minYEdge, .maxYEdge)
            } else if abs(destination.minY - origin.minY) < abs(destination.maxY - origin.maxY)  {
                (.minYEdge, .minYEdge)
            } else {
                (.maxYEdge, .maxYEdge)
            }
        case .vertical:
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
}
