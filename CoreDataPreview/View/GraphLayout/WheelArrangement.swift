//
//  WheelArrangement.swift
//  CoreDataPreview
//
//  Created by Pierre Gabory on 28/04/2024.
//

import SwiftUI

struct WheelArrangement<Content: View>: View {
    let layout: WheelLayout
    @ViewBuilder let content: () -> Content

    init(radius: CGFloat = 10, @ViewBuilder content: @escaping () -> Content) {
        self.layout = WheelLayout(radius: radius)
        self.content = content
    }

    var body: some View {
        layout.callAsFunction {
            content()
        }
    }
}

struct WheelLayout: Layout {
    let radius: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = subviews.map({ $0.dimensions(in: proposal).width }).max() ?? 0
        let height = subviews.map({ $0.dimensions(in: proposal).height }).max() ?? 0
        return CGSize(
            width: (width + radius) * 4,
            height: (height + radius) * 4
        )
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        if subviews.isEmpty { return }
        let count = subviews.count
        for (index, subview) in subviews.enumerated() {
            let angle = (-.pi / 2) + (CGFloat(index) / CGFloat(count) * .pi * 2)
            let position = CGPoint(
                x: (bounds.width / 4) * cos(angle) + bounds.midX,
                y: (bounds.height / 4) * sin(angle) + bounds.midY
            )
            subview.place(at: position, anchor: .center, proposal: proposal)
        }
    }
}

#Preview {
    WheelArrangement(radius: 30) {
        Group {
            Text("A")
            Text("B")
            Text("C")
            Text("D")
            Text("E")
        }
            .padding()
            .background()
    }
}
