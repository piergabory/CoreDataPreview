//
//  XcodeDataModelView.swift
//  CoreDataPreview
//
//  Created by Pierre Gabory on 21/04/2024.
//

import SwiftUI

struct XcodeDataModelView: XMLElementView {
    let element: XMLElement

    var relationshipLinks: [LogicalRelation<XcodeDataModelRelationship>] {
        let entities = element.elements(forName: "entity")
        let relationships = entities.flatMap { entity in
            let name = entity.attribute(forName: "name")?.stringValue ?? "No Name"
            return entity.elements(forName: "relationship").map { relationship in
                let relationship = XcodeDataModelRelationship(element: relationship, entity: name)
                return LogicalRelation<XcodeDataModelRelationship>(origin: relationship.id, destination: relationship.target)
            }
        }
        return relationships
    }

    var inheritanceLinks: [LogicalRelation<XcodeDataModelInheritance>] {
        let inheritanceLinks = element.elements(forName: "entity").compactMap { entity in
            if let inheritance = XcodeDataModelInheritance(element: entity), let parent = inheritance.parent {
                return LogicalRelation<XcodeDataModelInheritance>(origin: inheritance.id, destination: parent)
            } else {
                return nil
            }
        }
        print(inheritanceLinks)
        return inheritanceLinks
    }

    func makeBody() -> some View {
        ScrollView([.horizontal, .vertical]) {
            WheelArrangement {
                ForestLayout(forest: EntityTree.buildForest(from: element)) { tree in
                    XcodeDataModelEntityView(element: tree.element)
                        .fixedSize()
                        .padding()
                        .padding(.vertical)
                }
            }
            .frame(width: 1600, height: 1600)
        }
        .logicalPaths(relationshipLinks) { origin, destination in
            OrthogonalLogicalPathShape(origin: origin, destination: destination)
                .stroke {
                    Image(systemName: "chevron.left").offset(x: 20)
                }
                .foregroundStyle(.blue)
        }
        .logicalPaths(inheritanceLinks) { origin, destination in
            ShortestLogicalPathShape(origin: origin, destination: destination, connectionStrategy: FacingEdgesConnectionStrategy(edgeOrientation: .horizontal))
                .stroke {
                    Image(systemName: "chevron.left").offset(x: 4)
                }
                .foregroundStyle(.red)
        }
    }
}

struct XcodeDataModelEntityView: XMLElementView {
    let element: XMLElement

    var entity: String {
        element.attribute(forName: "name")?.stringValue ?? "No Name"
    }

    func makeBody() -> some View {
        VStack {
            attributeText("name")
                .font(.title3)
                .bold()

            Form {
                section(elementName: "attribute", sectionName: "Attributes") { attribute in
                    XcodeDataModelEntityAttributeView(element: attribute)
                }
                section(elementName: "relationship", sectionName: "Relationships") { relationship in
                    XcodeDataModelEntityRelationshipView(element: relationship)
                        .logicalNode(XcodeDataModelRelationship(element: relationship, entity: entity))
                }
            }
        }
        .padding()
        .background()
        .logicalNode(XcodeDataModelInheritance(element: element))
    }

    @ViewBuilder
    func section<Content: View>(
        elementName: String,
        sectionName: String,
        @ViewBuilder content: @escaping (XMLElement) -> Content
    ) -> some View {
        if element.elements(forName: elementName).isEmpty == false {
            Section {
                forEachElement(elementName) { attribute in
                    content(attribute)
                }
            } header: {
                Divider()
                Text(sectionName)
                    .font(.headline)
            }
        }
    }
}

struct XcodeDataModelEntityAttributeView: XMLElementView {
    let element: XMLElement

    func makeBody() -> some View {
        HStack {
            attributeText("name")
            Spacer()
            attributeText("attributeType")
                .foregroundStyle(.secondary)
        }
    }
}

struct XcodeDataModelEntityRelationshipView: XMLElementView {
    let element: XMLElement

    func makeBody() -> some View {
        HStack {
            attributeText("name")
            Spacer()
            attributeText("inverseName")
                .foregroundStyle(.secondary)
        }
    }
}

struct XcodeDataModelInheritance: Identifiable {
    let id: String
    let parent: String?

    init?(element: XMLElement) {
        guard let name = element.attribute(forName: "name")?.stringValue else { return nil }
        id = name
        parent = element.attribute(forName: "parentEntity")?.stringValue
    }
}

struct XcodeDataModelRelationship: Identifiable {
    var id: String
    let target: String

    init(element: XMLElement, entity: String) {
        let name = element.attribute(forName: "name")?.stringValue ?? "No Name"
        let reversedName = element.attribute(forName: "inverseName")?.stringValue ?? "Null"
        let reversedEntity = element.attribute(forName: "inverseEntity")?.stringValue ?? "Null"
        id = entity + "." + name
        target = reversedEntity + "." + reversedName
    }
}

#Preview {
    XcodeDataModelView(element: XMLDocument.preview.rootElement()!)
        .frame(minWidth: 800, minHeight: 600)
        .environment(ObjectOfInterest())
        .fixedSize()

}
