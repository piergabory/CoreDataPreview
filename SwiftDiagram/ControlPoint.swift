//
//  Diagram+ControlPoint.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 10/04/2024.
//

import SwiftUI

struct ControlPointPreferenceKey: PreferenceKey {
    typealias Value = [AnyHashable: Anchor<CGPoint>]
    static let defaultValue = Value()

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue()) { $1 }
    }
}

struct ControlPoint<ID: Hashable>: Identifiable, ViewModifier {
    let id: ID
    let placement: Anchor<CGPoint>.Source

    func body(content: Content) -> some View {
        content
            .anchorPreference(key: ControlPointPreferenceKey.self, value: placement) { [id: $0] }
    }
}

extension View {
    func controlPoint<ID: Hashable>(id: ID, placement: Anchor<CGPoint>.Source = .center) -> some View {
        modifier(ControlPoint<ID>(id: id, placement: placement))
    }

    func showControlPoints<Symbol: View>(@ViewBuilder symbol: @escaping () -> Symbol) -> some View {
        overlayPreferenceValue(ControlPointPreferenceKey.self) { preference in
            GeometryReader { proxy in
                let identifiedAnchors = preference.map { item in (id: item.key, anchors: item.value) }
                ForEach(identifiedAnchors, id: \.id) { item in
                    symbol()
                        .position(proxy[item.anchors])
                }
            }
        }
    }
}

#Preview {
    HStack {
        ForEach(1...10, id: \.self) { index in
            Text(index, format: .number)
                .padding()
                .background()
                .border(.primary)
                .controlPoint(id: index, placement: .top)
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
