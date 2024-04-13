//
//  XcodeDataModelView.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 13/04/2024.
//

import SwiftUI

struct XcodeDataModelView: View {
    let model: XcodeDataModelContent


    var relationGraph: [String: Set<String>] {
        model.entities.reduce(into: [:]) { graph, entity in
            for relationship in entity.relationships {
                graph[relationship.name] = [relationship.inverseName ?? relationship.destinationEntity ?? "void"]
            }
        }
    }

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 4)) {
            ForEach(model.entities) { entity in
                EntityView(entity: entity)
            }
        }
        .connect(relationGraph)
    }
}

#Preview {
    XcodeDataModelView(model: .preview)
        .frame(minWidth: 1000, minHeight: 1000)
        .background()
}
