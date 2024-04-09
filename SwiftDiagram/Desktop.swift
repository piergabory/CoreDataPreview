//
//  Desktop.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 09/04/2024.
//

import SwiftUI

struct Desktop<Data: RandomAccessCollection, ID: Hashable, Content: View>: DataContentView {
    let coordinateSpace = NamedCoordinateSpace.named("Desktop")
    let data: Data
    let idPath: KeyPath<Data.Element, ID>
    @ViewBuilder let content: (Data.Element) -> Content

    @State var offsets: [ID: CGSize] = [:]
    @State var activeDrag: ID?
    @State var pendingOffset: CGSize = .zero

    var body: some View {
        HStack {
            ForEach(data, id: idPath) { element in
                let id = element[keyPath: idPath]

                content(element)
                    .gesture(dragGesture(id: id))
                    .offset(offset(id: id))
            }
        }
        .coordinateSpace(coordinateSpace)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    init(data: Data, id idKeyPath: KeyPath<Data.Element, ID>, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.idPath = idKeyPath
        self.content = content
    }

    private func offset(id: ID) -> CGSize {
        var offset = offsets[id, default: .zero]
        if id == activeDrag {
            offset.width += pendingOffset.width
            offset.height += pendingOffset.height
        }
        return offset
    }

    private func dragGesture(id: ID) -> some Gesture {
        DragGesture(coordinateSpace: coordinateSpace)
            .onChanged { value in
                pendingOffset = value.translation
                activeDrag = id
            }
            .onEnded { value in
                activeDrag = nil
                pendingOffset = .zero
                offsets[id, default: .zero].width += value.translation.width
                offsets[id, default: .zero].height += value.translation.height
            }
    }
}

#Preview {
    Desktop(data: 1...10, id: \.self) { index in
        Text(index, format: .number)
            .padding()
            .background()
            .border(.primary)
    }
}
