//
//  EntityViewItem.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 11/04/2024.
//

import SwiftUI

struct EntityViewItem: View {
    let label: String
    let detail: String?

    init(_ label: String, detail: String? = nil) {
        self.label = label
        self.detail = detail
    }

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            if let detail {
                Text(detail)
                    .foregroundStyle(.secondary)
            }
        }
        .font(.body)
        .padding(.horizontal)
    }
}

#Preview {
    EntityViewItem("Item Name", detail: "Item detail")
        .fixedSize()
        .padding()
        .background()
}
