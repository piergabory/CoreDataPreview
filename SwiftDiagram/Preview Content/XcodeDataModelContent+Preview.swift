//
//  XcodeDataModelContent+Preview.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 13/04/2024.
//

import Foundation

extension XcodeDataModelContent {
    static var preview: Self {
        let file = Bundle.main.url(forResource: "preview_model", withExtension: nil)!
        let document = try! XMLDocument(contentsOf: file)
        return try! XcodeDataModelContentBuilder(document: document).build()
    }
}

extension XcodeDataModelContent.Entity {
    static var preview: Self {
        let max = XcodeDataModelContent.preview.entities.max { l, r in
            (l.attributes.count + l.relationships.count) < (r.attributes.count + r.relationships.count)
        }
        return max!
    }
}

extension XcodeDataModelContent.Entity.Attribute {
    static var preview: Self {
        XcodeDataModelContent.Entity.preview.attributes.first!
    }
}

extension XcodeDataModelContent.Entity.Relationship {
    static var preview: Self {
        XcodeDataModelContent.Entity.preview.relationships.first!
    }
}
