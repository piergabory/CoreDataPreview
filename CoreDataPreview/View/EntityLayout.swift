//
//  EntityLayout.swift
//  CoreDataPreview
//
//  Created by Pierre Gabory on 28/04/2024.
//

import Foundation

final class EntityTree: Tree, Comparable {
    let id: String
    let element: XMLElement
    private(set) var children: [EntityTree]

    var description: String {
        id + ": { " + children.map(\.description).joined(separator: ", ") + " }"
    }

    static func == (lhs: EntityTree, rhs: EntityTree) -> Bool {
        lhs.id == rhs.id && lhs.children == rhs.children
    }

    static func < (lhs: EntityTree, rhs: EntityTree) -> Bool {
        let lRelationCount = lhs.element.elements(forName: "relationship").count
        let rRelationCount = rhs.element.elements(forName: "relationship").count
        if lRelationCount == rRelationCount {
            return lhs.id < rhs.id
        } else {
            return lRelationCount < rRelationCount
        }
    }

    private init(id: String, element: XMLElement, children: [EntityTree] = []) {
        self.id = id
        self.element = element
        self.children = children
    }

    private func appending(_ child: EntityTree) -> EntityTree {
        EntityTree(id: id, element: element, children: (children + [child]).sorted())
    }

    static func buildForest(from model: XMLElement) -> [EntityTree] {
        let entities = model.elements(forName: "entity")

        var nodes: [String: EntityTree] = [:]
        for entity in entities {
            guard let name = entity.attribute(forName: "name")?.stringValue else { continue }
            nodes[name] = EntityTree(id: name, element: entity)
        }

        var childs = Set<String>()
        for entity in entities {
            guard
                let name = entity.attribute(forName: "name")?.stringValue,
                let current = nodes[name],
                let parentName = entity.attribute(forName: "parentEntity")?.stringValue,
                let parent = nodes[parentName]
            else { continue }
            nodes[parentName] = parent.appending(current)
            childs.insert(name)
        }

        let roots = nodes
            .filter { key, _ in
                childs.contains(key) == false
            }
            .values
            .sorted()

        print(roots)
        return roots
    }
}
