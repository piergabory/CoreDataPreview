//
//  XcodeDataModelContentBuilder.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 13/04/2024.
//

import Foundation

enum XcodeDataModelContentBuilderError: String, Error {
    case emptyDocument
    case noAttributeForEntity
    case noValueForAttribute
}

struct XcodeDataModelContentBuilder {
    let document: XMLDocument

    init(document: XMLDocument) {
        self.document = document
    }

    private var model: XMLElement {
        get throws {
            if let node = document.rootElement() { 
                node
            } else {
                throw XcodeDataModelContentBuilderError.emptyDocument
            }
        }
    }

    func build() throws -> XcodeDataModelContent {
        XcodeDataModelContent(
            entities: try entities(),
            properties: try modelProperties()
        )
    }

    private func entities() throws -> [XcodeDataModelContent.Entity] {
        try model.elements(forName: "entity").compactMap { entityElement in
            XcodeDataModelContent.Entity(
                properties: try entityProperties(entityElement),
                attributes: try entityAttributes(entityElement),
                relationships: try entityRelationships(entityElement)
            )
        }
    }

    private func entityAttributes(_ entity: XMLElement) throws -> [XcodeDataModelContent.Entity.Attribute] {
        try entity.elements(forName: "attribute").map { attribute in
            XcodeDataModelContent.Entity.Attribute(
                name: try attributeString("name", on: attribute),
                optional: try? attributeString("optional", on: attribute),
                attributeType: try? attributeString("attributeType", on: attribute),
                defaultValueString: try? attributeString("defaultValueString", on: attribute),
                usesScalarValueType: try? attributeString("usesScalarValueType", on: attribute)
            )
        }
    }

    private func entityRelationships(_ entity: XMLElement) throws -> [XcodeDataModelContent.Entity.Relationship] {
        try entity.elements(forName: "relationship").map { attribute in
            XcodeDataModelContent.Entity.Relationship(
                entity: try attributeString("name", on: entity),
                name: try attributeString("name", on: attribute),
                optional: try? attributeString("optional", on: attribute),
                maxCount: try? attributeString("maxCount", on: attribute),
                deletionRule: try? attributeString("deletionRule", on: attribute),
                destinationEntity: try? attributeString("destinationEntity", on: attribute),
                inverseName: try? attributeString("inverseName", on: attribute),
                inverseEntity: try? attributeString("inverseEntity", on: attribute)
            )
        }
    }

    private func entityProperties(_ entity: XMLElement) throws -> XcodeDataModelContent.Entity.Properties {
        XcodeDataModelContent.Entity.Properties(
            name: try attributeString("name", on: entity),
            representedClassName: try? attributeString("representedClassName", on: entity),
            syncable: try? attributeString("syncable", on: entity),
            codeGenerationType: try? attributeString("codeGenerationType", on: entity)
        )
    }

    private func modelProperties() throws -> XcodeDataModelContent.Properties {
        XcodeDataModelContent.Properties(
            type: try? attributeString("type", on: model),
            documentVersion: try? attributeString("documentVersion", on: model),
            lastSavedToolsVersion: try? attributeString("lastSavedToolsVersion", on: model),
            systemVersion: try? attributeString("systemVersion", on: model),
            userDefinedModelVersionIdentifier: try? attributeString("userDefinedModelVersionIdentifier", on: model)
        )
    }

    private func attributeString(_ attribute: String, on element: XMLElement) throws -> String {
        guard let attribute = element.attribute(forName: attribute) else { throw XcodeDataModelContentBuilderError.noAttributeForEntity }
        guard let string = attribute.stringValue else { throw XcodeDataModelContentBuilderError.noValueForAttribute }
        return string
    }
}
