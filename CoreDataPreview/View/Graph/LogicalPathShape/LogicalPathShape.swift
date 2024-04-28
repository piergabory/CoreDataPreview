//
//  LogicalPathShape.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 14/04/2024.
//

import SwiftUI

extension CGRectEdge {
    var angle: Angle {
        switch self {
        case .minXEdge: .degrees(180)
        case .minYEdge: .degrees(-90)
        case .maxXEdge: .degrees(0)
        case .maxYEdge: .degrees(90)
        }
    }
}

private enum PathTips {
    case start, end
}

protocol LogicalPathShape: Shape {
    var origin: CGPoint { get }
    var startAngle: Angle { get }
    var destination: CGPoint { get }
    var endAngle: Angle { get }
}

extension LogicalPathShape {
    func stroke<Start: View, End: View>(@ViewBuilder start: @escaping () -> Start? = { EmptyView() }, @ViewBuilder end: @escaping () -> End?) -> some View {
        Canvas { context, size in
            context.stroke(path(in: context.clipBoundingRect), with: .foreground)
            if let start = context.resolveSymbol(id: PathTips.start) {
                context.draw(start, at: origin)
            }
            if let end = context.resolveSymbol(id: PathTips.end) {
                context.draw(end, at: destination)
            }
        } symbols: {
            start()?.rotationEffect(startAngle).tag(PathTips.start)
            end()?.rotationEffect(endAngle).tag(PathTips.end)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ShortestLogicalPathShape(
        origin: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 25, height: 25)),
        destination: CGRect(origin: CGPoint(x: 100, y: 20), size: CGSize(width: 25, height: 25)),
        connectionStrategy: ClosestEdgeConnectionStrategy()
    )
    .stroke {
        Image(systemName: "chevron.left").frame(width: 8, height: 8).offset(x: 4)
    } end: {
        Image(systemName: "chevron.left").frame(width: 8, height: 8).offset(x: 4)
    }
}
