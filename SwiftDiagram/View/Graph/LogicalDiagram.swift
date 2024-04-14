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
        styleType _: Style.Type,
        shapeStyle: some ShapeStyle
    ) -> some View {
        backgroundPreferenceValue(LogicalNodePositions<Node>.self) { preference in
            ZStack {
                ForEach(links) { link in
                    if let originAnchor = preference.anchor(for: link.origin), let destinationAnchor = preference.anchor(for: link.destination) {
                        GeometryReader { proxy in
                            Style(origin: proxy[originAnchor], destination: proxy[destinationAnchor])
                                .stroke(shapeStyle)
                        }
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

// MARK: - Paths

protocol LogicalPathStyle: Shape {
    var origin: CGRect { get }
    var destination: CGRect { get }

    init(origin: CGRect, destination: CGRect)
}

extension LogicalPathStyle {
    func horizontalMidPoints() -> (origin: CGPoint, destination: CGPoint)? {
        if origin.maxX < destination.minX {
            (CGPoint(x: origin.maxX, y: origin.midY), CGPoint(x: destination.minX, y: destination.midY))
        } else if destination.maxX < origin.minX {
            (CGPoint(x: origin.minX, y: origin.midY), CGPoint(x: destination.maxX, y: destination.midY))
        } else {
            nil
        }
    }

    func verticalMidPoints() -> (origin: CGPoint, destination: CGPoint)? {
        if origin.maxY < destination.minY {
            (CGPoint(x: origin.midX, y: origin.maxY), CGPoint(x: destination.midX, y: destination.minY))
        } else if destination.maxY < origin.minY {
            (CGPoint(x: origin.midX, y: origin.minY), CGPoint(x: destination.midX, y: destination.maxY))
        } else {
            nil
        }
    }

    func closestMidPoints() -> (origin: CGPoint, destination: CGPoint)? {
        guard let (left, right) = horizontalMidPoints() else { return verticalMidPoints() }
        guard let (top, bottom) = verticalMidPoints() else { return horizontalMidPoints() }
        let vDelta = CGPoint(x: top.x - bottom.x, y: top.y - bottom.y)
        let vSquaredDistance = vDelta.x * vDelta.x + vDelta.y * vDelta.y
        let hDelta = CGPoint(x: left.x - right.x, y: left.y - right.y)
        let hSquaredDistance = hDelta.x * hDelta.x + hDelta.y * hDelta.y
        return hSquaredDistance < vSquaredDistance ? (left, right) : (top, bottom)
    }
}

struct DirectPathToMidPoint: LogicalPathStyle {
    let origin: CGRect
    let destination: CGRect

    func path(in rect: CGRect) -> Path {
        Path { path in
            if let (origin, destination) = closestMidPoints() {
                path.move(to: origin)
                path.addLine(to: destination)
            }
        }
    }
}

struct SaggingPathToMidPoint: LogicalPathStyle {
    let origin: CGRect
    let destination: CGRect

    func path(in rect: CGRect) -> Path {
        Path { path in
            if let (origin, destination) = closestMidPoints() {
                let control = CGPoint(x: (origin.x + destination.x) / 2, y: max(origin.y, destination.y))
                path.move(to: origin)
                path.addQuadCurve(to: destination, control: control)
            }
        }
    }
}

struct OrthogonalPath: LogicalPathStyle {
    let origin: CGRect
    let destination: CGRect

    func path(in rect: CGRect) -> Path {
        Path { path in
            if let (origin, destination) = horizontalMidPoints() {
                let halfwayx = (origin.x + destination.x) / 2
                path.move(to: origin)
                path.addLine(to: CGPoint(x: halfwayx, y: origin.y))
                path.addLine(to: CGPoint(x: halfwayx, y: destination.y))
                path.addLine(to: destination)
            } else if let (origin, destination) = verticalMidPoints() {
                let halfwayy = (origin.y + destination.y) / 2
                path.move(to: origin)
                path.addLine(to: CGPoint(x: origin.x, y: halfwayy))
                path.addLine(to: CGPoint(x: destination.x, y: halfwayy))
                path.addLine(to: destination)
            }
        }
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
