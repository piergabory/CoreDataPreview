//
//  DataModelLoadingView.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 12/04/2024.
//

import SwiftUI

struct DataModelLoadingView: View {
    let file: URL
    @State var xcDataModel: XcodeDataModelContent?
    @State var caughtError: Error?

    @ViewBuilder
    var body: some View {
        if let xcDataModel {
            XcodeDataModelView(model: xcDataModel)
        } else {
            if let caughtError {
                Text(caughtError.localizedDescription)
            }
            ProgressView()
                .alert($caughtError)
                .onAppear {
                    do {
                        let document = try loadDocument()
                        xcDataModel = try XcodeDataModelContentBuilder(document: document).build()
                    } catch {
                        caughtError = error
                        print(error)
                    }
                }
        }
    }

    private func loadDocument() throws -> XMLDocument {
        if file.startAccessingSecurityScopedResource() {
            defer {
                file.stopAccessingSecurityScopedResource()
            }
            return try XMLDocument(contentsOf: file)
        }
        fatalError()
    }
}
