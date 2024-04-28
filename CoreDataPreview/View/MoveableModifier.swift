//
//  MoveableModifier.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 09/04/2024.
//

import SwiftUI

extension View {
    func moveable() -> some View {
        modifier(MoveableModifier())
    }
}

struct MoveableModifier: ViewModifier {
    // Look at Gesture State
    @State var offset: CGSize = .zero
    @GestureState var pendingOffset: CGSize = .zero

    var dragGesture: some Gesture {
        DragGesture(coordinateSpace: .global)
            .updating($pendingOffset) { gestureValue, pendingOffset, _ in
                pendingOffset = gestureValue.translation
            }
            .onEnded {
                offset.width += $0.translation.width
                offset.height += $0.translation.height
            }
    }

    func body(content: Content) -> some View {
        content
            .gesture(dragGesture)
            .offset(offset)
            .offset(pendingOffset)
    }
}

#if DEBUG
#Preview {
    HStack {
        ForEach(1...10, id: \.self) { index in
            Text(index, format: .number)
                .padding()
                .background()
                .border(.primary)
                .moveable()
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
#endif
