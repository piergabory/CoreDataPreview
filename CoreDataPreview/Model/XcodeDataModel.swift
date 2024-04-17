//
//  XcodeDataModel.swift
//  CoreDataPreview
//
//  Created by Pierre Gabory on 16/04/2024.
//

import Foundation

struct XcodeDataModel {
    struct Entity {
        struct Attribute {
            let name: String
            let optional: String?
            let attributeType: String?
            let defaultValueString: String?
            let usesScalarValueType: String?
        }

        struct Relationship {
            let entity: String
            let name: String
            let optional: String?
            let maxCount: String?
            let deletionRule: String?
            let destinationEntity: String?
            let inverseName: String?
            let inverseEntity: String?
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
