//
//  SwiftDiagramApp.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 08/04/2024.
//

import SwiftUI

@main
struct SwiftDiagramApp: App {
    @State var selectedFile: URL?

    var body: some Scene {
        WindowGroup {
            if let selectedFile {
                DataModelLoadingView(file: selectedFile)
                    .toolbar {
                        Button("Close", systemImage: "xmark") {
                            self.selectedFile = nil
                        }
                    }
            } else {
                FilePickerView(supportedTypes: [.xcDataModel, .xcDataModelId, .data], selectedFile: $selectedFile)
            }
        }
    }
}
