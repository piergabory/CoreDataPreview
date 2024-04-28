//
//  DirectionnalEdgeConnectionStrategy.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 14/04/2024.
//

import SwiftUI

struct DirectionnalConnection: BoxConnectionStrategy {
    enum Direction { case up, down, right, left }
    let direction: Direction

    init(direction: Direction = .up) {
        self.direction = direction
    }

    func boxConnection(from origin: CGRect, to destination: CGRect) -> EdgePair {
        switch direction {
        case .up:
            (.minYEdge, .maxYEdge)
        case .down:
            (.maxYEdge, .minYEdge)
        case .right:
            (.minXEdge, .maxXEdge)
        case .left:
            (.maxXEdge, .minXEdge)
        }
    }
}
