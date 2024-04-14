//
//  XcodeDataModelView.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 13/04/2024.
//

import SwiftUI

struct XcodeDataModelView: View {
    let model: XcodeDataModelContent

    var inheritances: [LogicalPath<XcodeDataModelContent.Entity>] {
        model.entities.compactMap { entity in
            if let parent = entity.parentId {
                LogicalPath(origin: entity.id, destination: parent)
            } else {
                nil
            }
        }
    }

    var relationships: [LogicalPath<XcodeDataModelContent.Entity.Relationship>] {
        model.entities.flatMap(\.relationships).compactMap { relationship in
            LogicalPath(origin: relationship.id, destination: relationship.targetId)
        }
    }

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 4)) {
            ForEach(model.entities) { entity in
                EntityView(entity: entity)
            }
        }
        .logicalPaths(relationships, styleType: OrthogonalPath.self, shapeStyle: .blue)
        .logicalPaths(inheritances, styleType: DirectPathToMidPoint.self, shapeStyle: .red)
    }
}

#Preview {
    XcodeDataModelView(model: 
        XcodeDataModelContent(
            entities: XcodeDataModelContent.preview.entities,
            properties: XcodeDataModelContent.preview.properties
        )
    )
        .frame(minWidth: 1000, minHeight: 1000)
        .background()
}
