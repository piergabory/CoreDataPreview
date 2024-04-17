//
//  CoreDataPreviewApp.swift
//  CoreDataPreview
//
//  Created by Pierre Gabory on 16/04/2024.
//

import SwiftUI

@main
struct CoreDataPreviewApp: App {
    var body: some Scene {
        DocumentGroup(viewing: XcodeDataModelPackage.self) { configuration in
            VersionBrowser(document: configuration.document)
        }
    }
}
