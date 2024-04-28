//
//  VersionBrowser.swift
//  CoreDataPreview
//
//  Created by Pierre Gabory on 16/04/2024.
//

import SwiftUI

struct VersionBrowser: View {
    @State var selectedVersion: String? = nil
    @State var columnVisibility: NavigationSplitViewVisibility = .detailOnly
    let package: XcodeDataModelPackage

    var body: some View {
         NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $selectedVersion) {
                ForEach(package.modelVersions.keys.sorted(), id: \.self) { version in
                    Text(version)
                }
            }
            .navigationSplitViewColumnWidth(min: 200, ideal: 250)
        } detail: {
            if let selectedVersion, let model = package.modelVersions[selectedVersion]?.rootElement() {
                XcodeDataModelView(element: model)
            } else {
                Text("Select version.").font(.title)
            }
        }
        .onAppear {
            selectedVersion = package.modelVersions.keys.first
            columnVisibility = package.modelVersions.count > 1 ? .automatic : .detailOnly
        }
    }
}

#if DEBUG
#Preview {
    VersionBrowser(package: .preview)
        .frame(width: 800, height: 600)
        .environment(ObjectOfInterest())
}
#endif
