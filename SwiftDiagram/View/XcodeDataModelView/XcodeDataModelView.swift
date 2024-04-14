//
//  XcodeDataModelView.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 13/04/2024.
//

import SwiftUI

struct XcodeDataModelView: View {
    let model: XcodeDataModelContent


    var links: [LogicalPath<XcodeDataModelContent.Entity.Relationship>] {
        model.entities.flatMap(\.relationships).compactMap { relationship in
            if let target = relationship.inverseName {
                LogicalPath(origin: relationship.id, destination: relationship.targetId)
            } else {
                nil
            }
        }
    }

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 4)) {
            ForEach(model.entities) { entity in
                EntityView(entity: entity)
            }
        }
        .logicalPaths(links, styleType: OrthogonalPath.self, shapeStyle: .blue)
    }
}

#Preview {
    XcodeDataModelView(model: 
        XcodeDataModelContent(
            entities: Array(XcodeDataModelContent.preview.entities[4...9]),
            properties: XcodeDataModelContent.preview.properties
        )
    )
        .frame(minWidth: 1000, minHeight: 1000)
        .background()
}
