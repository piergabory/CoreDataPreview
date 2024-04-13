//
//  FilePickerView.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 12/04/2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct FilePickerView: View {
    let supportedTypes: [UTType]
    @State var showFileImporter = false
    @State var highlightDropZone = false

    @State var caughtError: Error?
    @Binding var selectedFile: URL?

    var body: some View {
        VStack {
            Text("Drop your model file here")
            HStack {
                Rectangle().frame(height: 0.5)
                Text("or")
                Rectangle().frame(height: 0.5)
            }
            .foregroundStyle(.secondary)
            Button("Import from Finder") {
                showFileImporter = true
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background() {
            RoundedRectangle(cornerRadius: 10)
                .stroke(style: StrokeStyle(dash: [10]))
                .foregroundStyle(.secondary)
        }
        .padding()
        .onDrop(of: supportedTypes, isTargeted: $highlightDropZone) { providers in
            do {
                fatalError("Drop not supported")
            } catch {
                caughtError = error
                return false
            }
        }
        .fileImporter(isPresented: $showFileImporter, allowedContentTypes: supportedTypes) { result in
            do {
                selectedFile = try result.get()
            } catch {
                caughtError = error
            }
        }
        .alert($caughtError)
    }
}

#Preview {
    FilePickerView(supportedTypes: [.text], selectedFile: .constant(nil))
}
