//
//  XMLInspectorView.swift
//  CoreDataPreview
//
//  Created by Pierre Gabory on 21/04/2024.
//

import SwiftUI
import Foundation

struct XMLInspectorView: View {
    let element: XMLElement?

    var body: some View {
        List {
            if element == nil {
                Text("Select an element to inspect.")
            }
            if let attributes = element?.attributes {
                Section("Attributes") {
                    ForEach(attributes) { attribute in
                        XMLAttributeView(attribute: attribute)
                    }
                }
            }
            if let elements = elementsCount() {
                Section("Elements") {
                    ForEach(elements) { element in
                        HStack {
                            Text(element.name + " count")
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(element.count, format: .number)
                                .foregroundStyle(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
        }
    }

    struct ElementCount: Identifiable {
        let name: String
        let count: Int
        var id: String { name }
    }

    private func elementsCount() -> [ElementCount]? {
        let childElements = element?.children?.filter { $0.kind == .element }
        guard let childElements else { return nil }
        let groupedByName = Dictionary(grouping: childElements) { $0.name ?? "None" }
        return groupedByName.compactMap { (key, value) in
            ElementCount(name: key, count: value.count)
        }
    }
}

struct XMLAttributeView: View {
    let attribute: XMLNode

    var name: String { deCamelize(attribute.name ?? "--") }
    var value: String { attribute.stringValue ?? "" }

    var body: some View {
        HStack {
            Text(name)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(value.isEmpty ? "None" : value)
                .italic(value.isEmpty)
                .foregroundStyle(value.isEmpty ? .tertiary : .primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func deCamelize(_ string: String) -> String {
        string.reduce("") { string, character in
            if character.isUppercase {
                string + " " + [character]
            } else {
                string + [character]
            }
        }
        .capitalized(with: .current)
    }
}

extension XMLNode: Identifiable {
    public var id: String {
        (name ?? "none_") + String(self.index)
    }
}

#if DEBUG
#Preview {
    let document = XMLDocument.preview
    return XMLInspectorView(element: document.rootElement()!.children!.last! as! XMLElement)
}
#endif
