//
//  DataContentView.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 10/04/2024.
//

import SwiftUI

protocol DataContentView: DynamicViewContent {
    associatedtype ID: Hashable
    associatedtype Content: View

    init(data: Data, id: KeyPath<Data.Element, ID>, @ViewBuilder content: @escaping (Data.Element) -> Content)
}

extension DataContentView where Data.Element: Identifiable, Data.Element.ID == ID {
    init(data: Data, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.init(data: data, id: \.id, content: content)
    }
}
