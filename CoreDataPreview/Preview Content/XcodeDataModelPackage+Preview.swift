//
//  XcodeDataModelPackage.swift
//  CoreDataPreview
//
//  Created by Pierre Gabory on 16/04/2024.
//

import SwiftUI
import UniformTypeIdentifiers

extension XcodeDataModelPackage {
    static let preview = XcodeDataModelPackage(versions: [
        "Version 0": .preview,
        "Version 1": .preview,
        "Version 2": .preview,
        "Version 3": .preview,
        "Version 4": .preview
    ])
}

extension XcodeDataModel {
    static let preview = XcodeDataModel(
        entities: [],
        properties: Properties(
            type: "Preview Data Model",
            documentVersion: "1.0.0",
            lastSavedToolsVersion: "2.0.0",
            systemVersion: "MacOS 14.4",
            userDefinedModelVersionIdentifier: "Version 0"
        )
    )
}
