//
//  XMLElementView.swift
//  CoreDataPreview
//
//  Created by Pierre Gabory on 22/04/2024.
//

import SwiftUI

protocol XMLElementView: View {
    associatedtype Content: View
    var element: XMLElement { get }
    func makeBody() -> Content
}

extension XMLElementView {
    var body: some View {
        makeBody().modifier(ObjectOfInterestSetter(element: element))
    }

    @ViewBuilder
    func attributeText(_ attributeName: String) -> Text? {
        if let stringValue = element.attribute(forName: attributeName)?.stringValue {
            Text(stringValue)
        }
    }

    @ViewBuilder
    func forEachElement<Content: View>(
        _ name: String,
        @ViewBuilder content: @escaping (XMLElement) -> Content
    ) -> some View {
        ForEach(element.elements(forName: name)) { entity in
            content(entity)
        }
    }
}

struct ObjectOfInterestSetter: ViewModifier {
    @Environment(ObjectOfInterest.self)
    var objectOfInterest

    let element: XMLElement

    var isSelected: Bool { objectOfInterest.selectedElement == element }

    func body(content: Content) -> some View {
        content
            .background {
                if isSelected {
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(.secondary, style: StrokeStyle(dash: [10]))
                } else {
                    Color.clear
                }
            }
            .onTapGesture {
                objectOfInterest.select(element)
            }
    }
}

