//
//  UTType+XCodeDataModel.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 12/04/2024.
//

import UniformTypeIdentifiers

extension UTType {
    static let xcDataModel = UTType(filenameExtension: "xcdatamodel")!
    static let xcDataModelId = UTType(filenameExtension: "xcdatamodelid")!
}
