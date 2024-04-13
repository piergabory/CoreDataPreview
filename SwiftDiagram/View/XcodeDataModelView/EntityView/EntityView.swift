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
        VStack(alignment: .leading) {
            Text(entity.properties.name)
                .font(.title2.bold())
                .padding(.horizontal)
                .frame(maxWidth: .infinity)

            if entity.attributes.isEmpty == false {
                AccordeonSection {
                    Label("Attributes", systemImage: "circle.grid.2x2.fill")
                } content: {
                    ForEach(entity.attributes) { attribute in
                        EntityViewItem(attribute.name, detail: attribute.attributeType)
                    }
                }
            }

            if entity.relationships.isEmpty == false {
                AccordeonSection {
                    Label("Relationships", systemImage: "app.connected.to.app.below.fill")
                } content: {
                    ForEach(entity.relationships) { relationship in
                        EntityViewItem(relationship.name, detail: relationship.destinationEntity)
                            .controlPoint(id: relationship.name)
                    }
                }
            }
        }
        .padding(.vertical)
        .fixedSize()
        .background(.regularMaterial)
        .cornerRadius(8)
        .moveable()
    }
}

#Preview {
    EntityView(entity: XcodeDataModelContent.Entity.preview)
}
