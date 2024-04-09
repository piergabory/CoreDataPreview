//
//  Diagram.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 10/04/2024.
//

import SwiftUI

extension View {
    func connect<ID: Hashable>(_ relationships: [ID: Set<ID>]) -> some View {
        backgroundPreferenceValue(ControlPointPreferenceKey.self) { preference in
            GeometryReader { proxy in
                Path { path in
                    for (originId, destinationIds) in relationships {
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
    HStack(spacing: 20) {
        ForEach(1...4, id: \.self) { index in
            Text(index, format: .number)
                .padding()
                .background()
                .border(.primary)
                .fixedSize()
                .controlPoint(id: index, placement: index.isMultiple(of: 2) ? .bottom : .top)
                .moveable()
                .offset(x: .random(in: -100..<100), y: .random(in: -100..<100))
        }
    }
    .padding(200)
    .connect([1: [1, 2, 3], 3: [2, 4]])
    .showControlPoints {
        Circle()
            .fill(.red)
            .stroke(.primary)
            .frame(width: 8, height: 8)
    }
}
