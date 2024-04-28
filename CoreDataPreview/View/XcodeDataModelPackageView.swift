//
//  XcodeDataModelPackageView.swift
//  CoreDataPreview
//
//  Created by Pierre Gabory on 21/04/2024.
//

import SwiftUI

struct XcodeDataModelPackageView: View {
    @State var showInspector = true
    @State var objectOfInterest = ObjectOfInterest()

    let package: XcodeDataModelPackage

    var body: some View {
        VersionBrowser(package: package)
            .inspector(isPresented: $showInspector) {
                XMLInspectorView(element: objectOfInterest.selectedElement)
                    .toolbar {
                        Button("Show Inspector", systemImage: "sidebar.right") {
                            showInspector.toggle()
                        }
                    }
            }
            .environment(objectOfInterest)
    }
}

#Preview {
    XcodeDataModelPackageView(package: .preview)
}
