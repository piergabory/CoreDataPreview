//
//  LogicalPath.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 14/04/2024.
//

import SwiftUI

struct LogicalPath<Trace: Shape, Start: View, End: View>: View {
    private enum Symbols {
        case start, end
    }

    let origin: CGPoint
    let destination: CGPoint

    @ViewBuilder let trace: () -> Trace
    @ViewBuilder let start: () -> Start?
    @ViewBuilder let end: () -> End?

    var body: some View {
        Canvas { context, size in
            if let start = context.resolveSymbol(id: Symbols.start) {
                context.draw(start, at: origin)
            }
            if let end = context.resolveSymbol(id: Symbols.end) {
                context.draw(end, at: destination)
            }
            context.stroke(trace().path(in: context.clipBoundingRect), with: .foreground)
        } symbols: {
            start()?.tag(Symbols.start)
            end()?.tag(Symbols.end)
        }
    }
}

#Preview {
    LogicalPath(
        origin: CGPoint(x: 25, y: 25),
        destination: CGPoint(x: 125, y: 125)
    ) {
        Rectangle()
    } start: {
        Circle().frame(width: 8, height: 8)
    } end: {
        Rectangle().frame(width: 8, height: 8)
    }

    .frame(width: 150, height: 150)
}
