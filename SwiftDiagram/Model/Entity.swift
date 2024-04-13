//
//  Entity.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 11/04/2024.
//

import Foundation

struct Entity: Identifiable {
    struct Property: Identifiable {
        let name: String
        let type: Any.Type
        let id: AnyHashable
    }

    struct RelationShip: Identifiable {
        let name: String
        let count: any RangeExpression
        let targetId: AnyHashable
        let id: AnyHashable
    }

    let name: String
    let id: AnyHashable

    let properties: [Property]
    let relationShip: [RelationShip]
}
