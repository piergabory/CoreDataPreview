//
//  XMLDocument+Preview.swift
//  CoreDataPreview
//
//  Created by Pierre Gabory on 21/04/2024.
//

import Foundation

extension XMLDocument {
    static let preview: XMLDocument = {
        let bundle = Bundle.main
        let previewFile = bundle.url(forResource: "wthealth_preview_model", withExtension: nil)!
        return try! XMLDocument(contentsOf: previewFile)
    }()
}
