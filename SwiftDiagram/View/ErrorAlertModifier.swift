//
//  ErrorAlertModifier.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 12/04/2024.
//

import SwiftUI

extension View {
    func alert(_ error: Binding<Error?>) -> some View {
        modifier(ErrorAlertModifier(error: error))
    }
}

struct ErrorAlertModifier: ViewModifier {
    @State var isPresented = false
    @Binding var error: Error? {
        didSet {
            isPresented = true
        }
    }

    func body(content: Content) -> some View {
        content
            .alert("Error", isPresented: $isPresented) {
                Button("OK") { isPresented = false }
            } message: {
                if let error {
                    Text(error.localizedDescription)
                }
            }
    }
}
