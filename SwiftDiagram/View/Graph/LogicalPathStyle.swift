//
//  LogicalPathStyle.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 14/04/2024.
//

import SwiftUI

protocol LogicalPathStyle {
    associatedtype Background: View
    associatedtype Overlay: View

    var origin: CGRect { get }
    var destination: CGRect { get }

    init(origin: CGRect, destination: CGRect)

    func background() -> Background
    func overlay() -> Overlay
}

extension LogicalPathStyle {
    @ViewBuilder
    func overlay() -> some View {
        if let (origin, destination) = closestMidPoints() {
            ZStack {
                Circle()
                    .frame(width: 8, height: 8)
                    .position(origin)
                Circle()
                    .frame(width: 8, height: 8)
                    .position(destination)
            }
        } else {
            EmptyView()
        }
    }

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

    @ViewBuilder
    func background() -> some View {
        Path { path in
            if let (origin, destination) = closestMidPoints() {
                path.move(to: origin)
                path.addLine(to: destination)
            }
        }
        .stroke(lineWidth: 1)
    }
}

struct SaggingPathToMidPoint: LogicalPathStyle {
    let origin: CGRect
    let destination: CGRect

    @ViewBuilder
    func background() -> some View {
        Path { path in
            if let (origin, destination) = closestMidPoints() {
                let control = CGPoint(x: (origin.x + destination.x) / 2, y: max(origin.y, destination.y))
                path.move(to: origin)
                path.addQuadCurve(to: destination, control: control)
            }
        }
        .stroke(lineWidth: 1)
    }
}

struct OrthogonalPath: LogicalPathStyle {
    let origin: CGRect
    let destination: CGRect

    func overlay() -> some View {
        ZStack {
            if let (origin, destination) = horizontalMidPoints() {
                Image(systemName: "chevron.right")
                    .frame(width: 4, alignment: .trailing)
                    .position(destination)
            } else if let (origin, destination) = verticalMidPoints() {
                Image(systemName: "chevron.down")
                    .frame(height: 4, alignment: .bottom)
                    .position(destination)
            } else {
                EmptyView()
            }
        }
    }

    @ViewBuilder
    func background() -> some View {
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
        .stroke(lineWidth: 1)
    }
}

