//
//  Diagram.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 08/04/2024.
//

import SwiftUI

struct Diagram<Data: RandomAccessCollection, ID: Hashable, Content: View>: View {
    typealias Datum = Data.Element
    typealias ContentBuilder = (Datum) -> Content
    typealias IDPath = KeyPath<Datum, ID>
    typealias Relationships = [ID: Set<ID>]
    typealias Anchors = [ID: CGPoint]

    let data: Data
    let relationships: Relationships
    let anchors: Anchors
    let id: IDPath

    @ViewBuilder
    let content: (Datum) -> Content

    var body: some View {
        GeometryReader { proxy in
            let bounds = proxy.frame(in: .local)

            Path { path in
                for (origin, destinations) in relationships {
                    guard let start = anchors(for: origin, in: bounds) else { continue }
                    for destination in destinations {
                        guard let end = anchors(for: destination, in: bounds) else { continue }
                        path.move(to: start)
                        path.addLine(to: end)
                    }
                }
            }
            .stroke(Color.primary)

            ForEach(data, id: id) { datum in
                content(datum)
                    .fixedSize()
                    .position(anchors(for: datum, in: bounds))
            }
        }
    }

    func anchors(for datum: Datum, in bounds: CGRect) -> CGPoint {
        anchors(for: datum[keyPath: id], in: bounds) ?? .zero
    }

    func anchors(for id: ID, in bounds: CGRect) -> CGPoint? {
        guard let normalized = anchors[id] else { return nil }
        return CGPoint(
            x: bounds.midX + normalized.x * bounds.width / 2,
            y: bounds.midY + normalized.y * bounds.height / 2
        )
    }

    init(data: Data, relationships: Relationships = [:], anchors: Anchors? = nil, id: IDPath, @ViewBuilder content: @escaping ContentBuilder) {
        self.data = data
        self.relationships = relationships
        self.id = id
        self.content = content

        if let anchors {
            self.anchors = anchors
        } else {
            self.anchors = data
                .map { $0[keyPath: id] }
                .enumerated()
                .reduce(into: [:]) { anchors, item in
                    let placement = CGFloat(item.offset) / CGFloat(data.count)
                    let angle = placement * 2 * .pi
                    anchors[item.element] = CGPoint(x: sin(angle), y: cos(angle))
                }
        }
    }
}

extension Diagram where Datum: Identifiable, ID == Data.Element.ID {
    init(data: Data, relationships: Relationships = [:], anchors: Anchors = [:], @ViewBuilder content: @escaping ContentBuilder) {
        self.init(data: data, relationships: relationships, anchors: anchors, id: \.id, content: content)
    }
}

#Preview {
    Diagram(
        data: Array(1...10),
        relationships: [1: [2], 3: [2, 4], 8: [1, 2, 3, 4], 9: [5, 7]],
        id: \.self
    ) { item in
        Text(item, format: .number)
            .padding()
            .background()
            .border(.primary)
    }
    .padding(100)
}
