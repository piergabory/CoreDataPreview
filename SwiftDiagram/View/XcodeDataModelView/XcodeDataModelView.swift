//
//  XcodeDataModelView.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 13/04/2024.
//

import SwiftUI

struct XcodeDataModelView: View {
    let model: XcodeDataModelContent

    var inheritances: [LogicalRelation<XcodeDataModelContent.Entity>] {
        model.entities.compactMap { entity in
            if let parent = entity.parentId {
                LogicalRelation(origin: entity.id, destination: parent)
            } else {
                nil
            }
        }
    }

    var relationships: [LogicalRelation<XcodeDataModelContent.Entity.Relationship>] {
        model.entities.flatMap(\.relationships).compactMap { relationship in
            LogicalRelation(origin: relationship.id, destination: relationship.targetId)
        }
    }

    var body: some View {
        LazyHGrid(rows: Array(repeating: GridItem(), count: 3)) {
            ForEach(model.entities) { entity in
                EntityView(entity: entity)
                    .padding(50)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .logicalPaths(relationships) {
            OrthogonalLogicalPathShape(origin: $0, destination: $1)
                .stroke {
                    Image(systemName: "chevron.left").offset(x: 4)
                }
                .foregroundStyle(.blue)
        }
        .logicalPaths(inheritances) {
            ShortestLogicalPathShape(origin: $0, destination: $1, edgeOffset: 20, connectionStrategy: DirectionnalConnection())
                .stroke {
                    Circle().frame(width: 6)
                } end: {
                    Image(systemName: "chevron.left").offset(x: 4)
                }
                .foregroundStyle(.red)
        }
        .background()
    }
}

#Preview {
    XcodeDataModelView(model: .preview)
        .background()
        .frame(width: 1000)
}
