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

    func logicalPaths<Node: Identifiable, Style: LogicalPathStyle>(
        _ links: [LogicalPath<Node>],
        styleType: Style.Type,
        shapeStyle: some ShapeStyle
    ) -> some View {
        self.backgroundPreferenceValue(LogicalNodePositions<Node>.self) { preference in
            logicalPathLayer(links, nodePositions: preference, styleType: styleType) { style in
                style
                    .background()
                    .foregroundStyle(shapeStyle)
            }
        }
        .overlayPreferenceValue(LogicalNodePositions<Node>.self) { preference in
            logicalPathLayer(links, nodePositions: preference, styleType: styleType) { style in
                style
                    .overlay()
                    .foregroundStyle(shapeStyle)
            }
        }
    }

    private func logicalPathLayer<Node: Identifiable, Style: LogicalPathStyle, Layer: View>(
        _ links: [LogicalPath<Node>],
        nodePositions: LogicalNodePositions<Node>,
        styleType _: Style.Type,
        @ViewBuilder layer: @escaping (Style) -> Layer
    ) -> some View {
        ZStack {
            ForEach(links) { link in
                if let originAnchor = nodePositions.anchor(for: link.origin), let destinationAnchor = nodePositions.anchor(for: link.destination) {
                    GeometryReader { proxy in
                        layer(Style(origin: proxy[originAnchor], destination: proxy[destinationAnchor]))
                    }
                }
            }
        }
    }
}

struct LogicalPath<Node: Identifiable>: Hashable, Identifiable {
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
    .logicalPaths([LogicalPath<Node>(origin: "Hello", destination: "World")], styleType: OrthogonalPath.self, shapeStyle: .red)
    .logicalPaths([LogicalPath<Node>(origin: "Salut", destination: "Monde")], styleType: DirectPathToMidPoint.self, shapeStyle: .green)
    .logicalPaths([LogicalPath<Node>(origin: "Universe", destination: "Howdy")], styleType: SaggingPathToMidPoint.self, shapeStyle: .blue)
    .frame(width: 500, height: 500)
}
