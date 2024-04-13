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

    var relationGraph: [String: Set<String>] {
        guard let xcDataModel else { return [:] }
        return xcDataModel.entities.reduce(into: [:]) { graph, entity in
            for relationship in entity.relationships {
                graph["trailing_" + relationship.name] = ["leading_" + (relationship.inverseName ?? relationship.destinationEntity ?? "void")]
            }
        }

    }


    var body: some View {
        VStack {
            if let xcDataModel {
                ScrollView([.horizontal, .vertical]) {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 4)) {
                        ForEach(xcDataModel.entities) { entity in
                            EntityView(entity: entity)
                        }
                    }
                    .showControlPoints {
                        Circle()
                            .foregroundStyle(.red)
                            .frame(width: 8, height: 8)
                    }
                    .connect(relationGraph)
                }
                .background()
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
