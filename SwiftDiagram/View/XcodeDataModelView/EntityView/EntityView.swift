//
//  EntityView.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 11/04/2024.
//

import SwiftUI

struct EntityView: View {
    let entity: XcodeDataModelContent.Entity

    var body: some View {
        VStack(spacing: 0) {
            Text(entity.properties.name)
                .font(.title2.bold())
                .padding()

            if entity.attributes.isEmpty == false {
                AccordeonSection { _ in
                    Label("Attributes", systemImage: "circle.grid.2x2.fill")
                } content: {
                    ForEach(entity.attributes) { attribute in
                        EntityViewItem(attribute.name, detail: attribute.attributeType)
                    }
                }
            }

            if entity.relationships.isEmpty == false {
                AccordeonSection { isExpanded in
                    ZStack {
                        Label("Relationships", systemImage: "app.connected.to.app.below.fill")
                        if isExpanded == false {
                            ForEach(entity.relationships) { relationship in
                                Color.clear
                                    .logicalNode(relationship)
                            }
                        }
                    }
                } content: {
                    ForEach(entity.relationships) { relationship in
                        EntityViewItem(relationship.name, detail: relationship.inverseName)
                            .logicalNode(relationship)
                    }
                }
            }
        }
        .fixedSize()
        .background(.regularMaterial)
        .cornerRadius(8)
        .moveable()
    }
}

#Preview {
    EntityView(entity: XcodeDataModelContent.Entity.preview)
}
