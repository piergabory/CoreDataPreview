//
//  Diagram.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 10/04/2024.
//

import SwiftUI

struct Diagram<AnchorID: Hashable, Content: View>: View {
    let connections: [AnchorID: Set<AnchorID>]
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .backgroundPreferenceValue(ControlPointPreferenceKey.self) { preference in
                GeometryReader { proxy in
                    Path { path in
                        for (originId, destinationIds) in connections {
                            guard let origin = preference[originId] else { continue }
                            for destinationId in destinationIds {
                                guard let destination = preference[destinationId] else { continue }
                                path.move(to: proxy[origin])
                                path.addLine(to: proxy[destination])
                            }
                        }
                    }
                    .stroke(.primary)
                }
            }
    }
}

#Preview {
    Diagram(connections: [1: [1, 2, 3], 3: [2, 4], 5: [6]]) {
        Desktop(data: 1...10, id: \.self) { index in
            Text(index, format: .number)
                .padding()
                .background()
                .border(.primary)
                .controlPoint(id: index, placement: index.isMultiple(of: 2) ? .bottom : .top)
        }
    }
    .padding()
    .showControlPoints {
        Circle()
            .fill(.red)
            .stroke(.primary)
            .frame(width: 8, height: 8)
    }
}
