//
//  ObjectOfInterest.swift
//  CoreDataPreview
//
//  Created by Pierre Gabory on 21/04/2024.
//

import Foundation

@Observable
final class ObjectOfInterest {
    private(set) var selectedElement: XMLElement?

    func select(_ element: XMLElement) {
        selectedElement = element
    }
}
