//
//  EntityLayout.swift
//  CoreDataPreview
//
//  Created by Pierre Gabory on 28/04/2024.
//

import Foundation

struct EntityTree: Tree {
    let id: String
    let element: XMLElement
    private(set) var children: [EntityTree]

    var description: String {
        id + ": { " + children.map(\.description).joined(separator: ", ") + " }"
    }

    private init(id: String, element: XMLElement, children: [EntityTree] = []) {
        self.id = id
        self.element = element
        self.children = children
    }

    private func appending(_ child: EntityTree) -> EntityTree {
        EntityTree(id: id, element: element, children: children + [child])
    }

    static func buildForest(from model: XMLElement) -> [EntityTree] {
        let entities = model.elements(forName: "entity")

        var nodes: [String: EntityTree] = [:]
        for entity in entities {
            guard let name = entity.attribute(forName: "name")?.stringValue else { continue }
            nodes[name] = EntityTree(id: name, element: entity)
        }

        for entity in entities {
            guard
                let name = entity.attribute(forName: "name")?.stringValue,
                let current = nodes[name],
                let parentName = entity.attribute(forName: "parentEntity")?.stringValue,
                var parent = nodes[parentName]
            else { continue }
            nodes[parentName] = parent.appending(current)
            nodes[name] = nil
        }

        return Array(nodes.values).sorted {
            $0.id < $1.id
        }
    }
}
