//
//  XcodeDataModelContent.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 13/04/2024.
//

import Foundation

struct XcodeDataModelContent {
    struct Entity: Identifiable {
        struct Attribute: Decodable, Identifiable {
            let name: String
            let optional: String?
            let attributeType: String?
            let defaultValueString: String?
            let usesScalarValueType: String?

            var id: AnyHashable { "Attribute_" + name }
        }

        struct Relationship: Decodable, Identifiable {
            let name: String
            let optional: String?
            let maxCount: String?
            let deletionRule: String?
            let destinationEntity: String?
            let inverseName: String?
            let inverseEntity: String?

            var id: AnyHashable { "Relationship_" + name }
            var targetId: AnyHashable { "Relationship_" + (inverseName ?? "void") }
        }

        struct Properties {
            let name: String
            let representedClassName: String?
            let syncable: String?
            let codeGenerationType: String?
        }

        let properties: Properties
        let attributes: [Attribute]
        let relationships: [Relationship]

        var id: AnyHashable { "Entity_" + properties.name }
    }

    struct Properties {
        let type: String?
        let documentVersion: String?
        let lastSavedToolsVersion: String?
        let systemVersion: String?
        let userDefinedModelVersionIdentifier: String?
    }

    let entities: [Entity]
    var properties: Properties
}
