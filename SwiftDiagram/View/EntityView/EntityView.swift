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
                        ZStack {
                            EntityViewItem(relationship.name, detail: relationship.destinationEntity)
                            HStack {
                                Spacer().controlPoint(id: "leading_" + relationship.name, placement: .leading)
                                Spacer().controlPoint(id: "trailing_" + relationship.name, placement: .trailing)
                            }
                        }
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
