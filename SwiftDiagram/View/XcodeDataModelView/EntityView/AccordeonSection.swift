//
//  AccordeonSection.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 13/04/2024.
//

import SwiftUI

struct AccordeonSection<Title: View, Content: View>: View {
    @ViewBuilder let header: (Bool) -> Title
    @ViewBuilder let content: () -> Content
    @State var isExpanded = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                Divider()
                HStack {
                    header(isExpanded)
                    Image(systemName: "chevron.up")
                        .scaleEffect(y: isExpanded ? -1 : 1)
                }
                .font(.headline)
                .padding(.horizontal)
                Divider()
                    .opacity(isExpanded ? 1 : 0)
            }
            .background(.regularMaterial)
            .onTapGesture {
                withAnimation { isExpanded.toggle() }
            }
            .zIndex(1)

            if isExpanded {
                VStack(alignment: .leading) {
                    content()
                }
            }
        }
        .clipped()
    }
}

#Preview {
    AccordeonSection { _ in
        Label("Title", systemImage: "star.fill")
    } content: {
        Text("Content").frame(width: 100, height: 100)
    }
    .padding()
    .fixedSize()
    .frame(width: 200, height: 200)
}
