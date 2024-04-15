//
//  NetworkDiagram.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 13/04/2024.
//

import SwiftUI

extension View {
    func logicalNode<Node: Identifiable>(_ node: Node) -> some View {
        anchorPreference(key: LogicalNodePositions<Node>.self, value: .bounds) { anchor in
            LogicalNodePositions(node: node, bounds: anchor)
        }
    }

    func logicalPaths<Node: Identifiable, Layer: View>(
        _ links: [LogicalRelation<Node>],
        pathLayer: @escaping (CGRect, CGRect) -> Layer
    ) -> some View {
        backgroundPreferenceValue(LogicalNodePositions<Node>.self) { nodePositions in
            ForEach(links) { link in
                if let originAnchor = nodePositions.anchor(for: link.origin), let destinationAnchor = nodePositions.anchor(for: link.destination) {
                    GeometryReader { proxy in
                        pathLayer(proxy[originAnchor], proxy[destinationAnchor])
                    }
                }
            }
        }
    }
}

struct LogicalRelation<Node: Identifiable>: Hashable, Identifiable {
    let origin: Node.ID
    let destination: Node.ID
    var id: Self { self }
}

struct LogicalNodePositions<Node: Identifiable>: PreferenceKey {
    private var anchors: [Node.ID: Anchor<CGRect>]

    private init(anchors: [Node.ID: Anchor<CGRect>] = [:]) {
        self.anchors = anchors
    }

    init(node: Node, bounds: Anchor<CGRect>) {
        self.anchors = [node.id: bounds]
    }

    mutating func merge(_ other: Self) {
        anchors.merge(other.anchors) { $1 }
    }

    func anchor(for id: Node.ID) -> Anchor<CGRect>? {
        anchors[id]
    }

    static var defaultValue: Self { Self() }

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue())
    }
}

#Preview {
    struct Node: Identifiable {
        let id: String
    }

    struct Box: View {
        let name: String

        var body: some View {
            Text(name)
                .padding()
                .background()
                .border(.primary)
                .logicalNode(Node(id: name))
                .moveable()
        }
    }

    return HStack {
        VStack {
            Box(name: "Hello")
            Spacer()
            Box(name: "Salut")
            Spacer()
            Box(name: "Howdy")
        }
        Spacer()
        VStack {
            Box(name: "Universe")
            Spacer()
            Box(name: "World")
            Spacer()
            Box(name: "Monde")
        }
    }
    .logicalPaths([LogicalRelation<Node>(origin: "Hello", destination: "World")]) {
        OrthogonalLogicalPathShape(origin: $0, destination: $1)
            .stroke {
                Circle().frame(width: 8, height: 8)
            } end: {
                Image(systemName: "chevron.left").frame(width: 8, height: 8).offset(x: 4)
            }
    }
    .logicalPaths([LogicalRelation<Node>(origin: "Salut", destination: "Monde")]) {
        OrthogonalLogicalPathShape(origin: $0, destination: $1)
            .stroke {
                Circle().frame(width: 8, height: 8)
            } end: {
                Image(systemName: "chevron.left").frame(width: 8, height: 8).offset(x: 4)
            }
    }
    .logicalPaths([LogicalRelation<Node>(origin: "Universe", destination: "Howdy")]) {
        ShortestLogicalPathShape(origin: $0, destination: $1)
            .stroke {
                Circle().frame(width: 8, height: 8)
            } end: {
                Image(systemName: "chevron.left").frame(width: 8, height: 8).offset(x: 4)
            }
    }
}
