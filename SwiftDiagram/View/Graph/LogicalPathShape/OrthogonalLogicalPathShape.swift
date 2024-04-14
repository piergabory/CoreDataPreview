//
//  OrthogonalLogicalPathShape.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 14/04/2024.
//

import SwiftUI

struct OrthogonalLogicalPathShape: LogicalPathShape {
    let origin: CGPoint
    let startEdge: CGRectEdge
    let destination: CGPoint
    let endEdge: CGRectEdge
    let edgeOffset: CGFloat

    init(origin: CGRect, destination: CGRect, edgeOffset: CGFloat = 10, connectionStrategy: BoxConnectionStrategy = VerticalFacingEdges()) {
        (startEdge, endEdge) = connectionStrategy.boxConnection(from: origin, to: destination)
        self.origin = origin.midPoint(along: startEdge)
        self.destination = destination.midPoint(along: endEdge)
        self.edgeOffset = edgeOffset
    }

    func path(in rect: CGRect) -> Path {
        let originOffset = offset(origin, from: startEdge)
        let destinationOffset = offset(destination, from: endEdge)
        let points = [origin, originOffset]
            + midPoints(from: startEdge, at: originOffset, to: endEdge, at: destinationOffset)
            + [destinationOffset, destination]
        return Path { path in
            path.addLines(points)
        }
    }

    var startAngle: Angle {
        startEdge.angle
    }

    var endAngle: Angle {
        endEdge.angle
    }

    private func midPoints(from startEdge: CGRectEdge, at origin: CGPoint, to endEdge: CGRectEdge, at destination: CGPoint) -> [CGPoint] {
        let bounds = CGRect(
            x: origin.x,
            y: origin.y,
            width: destination.x - origin.x,
            height: destination.y - origin.y
        )
        return switch (startEdge, endEdge) {
        case (.maxXEdge, .minXEdge), (.minXEdge, .maxXEdge): 
            [CGPoint(x: bounds.midX, y: origin.y), CGPoint(x: bounds.midX, y: destination.y)]
        case (.maxYEdge, .minYEdge), (.minYEdge, .maxYEdge):
            [CGPoint(x: origin.x, y: bounds.midY), CGPoint(x: destination.x, y: bounds.midY)]
        case (.minXEdge, .minXEdge):
            [CGPoint(x: bounds.minX, y: origin.y), CGPoint(x: bounds.minX, y: destination.y)]
        case (.maxXEdge, .maxXEdge):
            [CGPoint(x: bounds.maxX, y: origin.y), CGPoint(x: bounds.maxX, y: destination.y)]
        case (.minYEdge, .minYEdge):
            [CGPoint(x: origin.x, y: bounds.minY), CGPoint(x: destination.x, y: bounds.minY)]
        case (.maxYEdge, .maxYEdge):
            [CGPoint(x: origin.x, y: bounds.maxY), CGPoint(x: destination.x, y: bounds.maxY)]
        case (.minXEdge, .minYEdge), (.minYEdge, .minXEdge):
            [CGPoint(x: bounds.minX, y: bounds.minY)]
        case (.maxXEdge, .minYEdge), (.minYEdge, .maxXEdge):
            [CGPoint(x: bounds.maxX, y: bounds.minY)]
        case (.minXEdge, .maxYEdge), (.maxYEdge, .minXEdge):
            [CGPoint(x: bounds.minX, y: bounds.maxY)]
        case (.maxXEdge, .maxYEdge), (.maxYEdge, .maxXEdge):
            [CGPoint(x: bounds.maxX, y: bounds.maxY)]
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
        OrthogonalLogicalPathShape(
            origin: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 25, height: 25)),
            destination: CGRect(origin: CGPoint(x: 75, y: 75), size: CGSize(width: 25, height: 25)),
            edgeOffset: 2,
            connectionStrategy: VerticalFacingEdges()
        )
        .stroke()

        OrthogonalLogicalPathShape(
            origin: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 25, height: 25)),
            destination: CGRect(origin: CGPoint(x: 75, y: 0), size: CGSize(width: 25, height: 25)),
            connectionStrategy: HorizontalFacingEdges()
        )
        .stroke()

        OrthogonalLogicalPathShape(
            origin: CGRect(origin: CGPoint(x: 5, y: 0), size: CGSize(width: 25, height: 25)),
            destination: CGRect(origin: CGPoint(x: 0, y: 75), size: CGSize(width: 35, height: 25)),
            connectionStrategy: VerticalFacingEdges()
        )
        .stroke()

        OrthogonalLogicalPathShape(
            origin: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 25, height: 25)),
            destination: CGRect(origin: CGPoint(x: 75, y: 75), size: CGSize(width: 25, height: 25)),
            connectionStrategy: ClosestEdge()
        )
        .stroke()
    }
    .frame(width: 100, height: 100)
    .border(.red)
    .padding()
}
