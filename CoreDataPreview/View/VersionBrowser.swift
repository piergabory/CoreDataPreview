//
//  VersionBrowser.swift
//  CoreDataPreview
//
//  Created by Pierre Gabory on 16/04/2024.
//

import SwiftUI

struct VersionBrowser: View {
    let document: XcodeDataModelPackage
    @State var selectedVersion: String?

    init(document: XcodeDataModelPackage) {
        self.document = document
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedVersion) {
                ForEach(document.modelVersions.keys.sorted(), id: \.self) { version in
                    Text(version)
                }
            }
        } detail: {
            if let selectedVersion {
                HStack {
                    Text(String(reflecting: document.modelVersions[selectedVersion]))
                    Divider()

                }
                .inspector(isPresented: .constant(true)) {
                    Text(String(reflecting: document.modelVersions[selectedVersion]))
                }
            }
        }
        .onAppear {
            selectedVersion = document.modelVersions.keys.first
        }
    }
}


#Preview {
    VersionBrowser(document: XcodeDataModelPackage.preview)
}
