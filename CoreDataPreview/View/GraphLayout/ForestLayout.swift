//
//  ForestLayout.swift
//  CoreDataPreview
//
//  Created by Pierre Gabory on 28/04/2024.
//

import SwiftUI

protocol Tree: Identifiable {
    var children: [Self] { get }
}

struct ForestLayout<T: Tree, Content: View>: View {
    let forest: [T]
    @ViewBuilder let content: (T) -> Content

    init(forest: [T], @ViewBuilder content: @escaping (T) -> Content) {
        self.forest = forest
        self.content = content
    }

    var body: some View {
        ForEach(forest) { tree in
            VStack {
                content(tree)
                HStack(alignment: .top) {
                    ForestLayout(forest: tree.children, content: content)
                }
            }
        }
    }
}

#Preview {
    struct StringTree: Tree {
        let id: String
        let children: [Self]
    }

    return ForestLayout(
        forest: [
            StringTree(id: "Root", children: [
                StringTree(id: "Child 1", children: []),
                StringTree(id: "Child 2", children: [
                    StringTree(id: "Child 2.1", children: []),
                    StringTree(id: "Child 2.2", children: []),
                    StringTree(id: "Child 2.3", children: []),
                ]),
                StringTree(id: "Child 3", children: [
                    StringTree(id: "Child 3.1", children: [
                        StringTree(id: "Child 3.1.1", children: []),
                        StringTree(id: "Child 3.1.2", children: [])
                    ]),
                    StringTree(id: "Child 3.2", children: []),
                ]),
            ]),
            StringTree(id: "Empty", children: []),
        ]
    ) { node in
        Text(node.id).padding().background()
            .padding(1)
    }
}
