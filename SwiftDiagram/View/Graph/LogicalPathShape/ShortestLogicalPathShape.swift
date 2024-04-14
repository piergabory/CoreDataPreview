//
//  ShortestLogicalPathShape.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 14/04/2024.
//

import SwiftUI

struct ShortestLogicalPathShape: LogicalPathShape {
    let origin: CGPoint
    let startEdge: CGRectEdge
    let destination: CGPoint
    let endEdge: CGRectEdge
    let edgeOffset: CGFloat

    init(origin: CGRect, destination: CGRect, edgeOffset: CGFloat = 0, connectionStrategy: BoxConnectionStrategy = VerticalFacingEdges()) {
        (startEdge, endEdge) = connectionStrategy.boxConnection(from: origin, to: destination)
        self.origin = origin.midPoint(along: startEdge)
        self.destination = destination.midPoint(along: endEdge)
        self.edgeOffset = edgeOffset
    }

    var startAngle: Angle {
        edgeOffset == 0 ? .radians(pitch) : startEdge.angle
    }

    var endAngle: Angle {
        edgeOffset == 0 ? .radians(pitch - .pi) : endEdge.angle
    }

    private var pitch: CGFloat {
        let Δx = destination.x - origin.x
        let Δy = destination.y - origin.y
        if Δy == 0 { return 0 }
        return atan(Δy / Δx)
    }

    func path(in rect: CGRect) -> Path {
        let originOffset = offset(origin, from: startEdge)
        let destinationOffset = offset(destination, from: endEdge)
        let points = [origin, originOffset, destinationOffset, destination]
        return Path { path in
            path.addLines(points)
        }
    }

    private func offset(_ point: CGPoint, from edge: CGRectEdge) -> CGPoint {
        var point = point
        switch edge {
        case .minXEdge: point.x -= edgeOffset
        case .minYEdge: point.y -= edgeOffset
        case .maxXEdge: point.x += edgeOffset
        case .maxYEdge: point.y += edgeOffset
        }
        return point
    }
}

#Preview {
    Group {
        ShortestLogicalPathShape(
            origin: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 25, height: 25)),
            destination: CGRect(origin: CGPoint(x: 75, y: 75), size: CGSize(width: 25, height: 25)),
            edgeOffset: 2
        )
        .stroke()

        ShortestLogicalPathShape(
            origin: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 25, height: 25)),
            destination: CGRect(origin: CGPoint(x: 75, y: 0), size: CGSize(width: 25, height: 25))
        )
        .stroke()

        ShortestLogicalPathShape(
            origin: CGRect(origin: CGPoint(x: 5, y: 0), size: CGSize(width: 25, height: 25)),
            destination: CGRect(origin: CGPoint(x: 0, y: 75), size: CGSize(width: 35, height: 25))
        )
        .stroke()

        ShortestLogicalPathShape(
            origin: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 25, height: 25)),
            destination: CGRect(origin: CGPoint(x: 75, y: 75), size: CGSize(width: 25, height: 25))
        )
        .stroke()
    }
    .frame(width: 100, height: 100)
    .border(.red)
    .padding()
}
