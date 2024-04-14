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
            let entity: String
            let name: String
            let optional: String?
            let maxCount: String?
            let deletionRule: String?
            let destinationEntity: String?
            let inverseName: String?
            let inverseEntity: String?

            var id: String {
                entity + "_" + name
            }

            var targetId: String {
                if let inverseName, let inverseEntity {
                    inverseEntity + "_" + inverseName
                } else if let destinationEntity {
                    destinationEntity + "_void"
                } else {
                    "void"
                }
            }
        }

        struct Properties {
            let name: String
            let parentName: String?
            let representedClassName: String?
            let syncable: String?
            let codeGenerationType: String?
        }

        let properties: Properties
        let attributes: [Attribute]
        let relationships: [Relationship]

        var id: AnyHashable { "Entity_" + properties.name }
        var parentId: AnyHashable? { properties.parentName.map { "Entity_" + $0 } }
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
