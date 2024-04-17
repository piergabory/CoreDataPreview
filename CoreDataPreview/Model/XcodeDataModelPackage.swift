//
//  XcodeDataModelPackage.swift
//  CoreDataPreview
//
//  Created by Pierre Gabory on 16/04/2024.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let xcdatamodeld = UTType(filenameExtension: "xcdatamodeld", conformingTo: .package)!
    static let xcdatamodel = UTType(filenameExtension: "xcdatamodel", conformingTo: .package)!
}

struct XcodeDataModelPackage: FileDocument {
    enum PackagingError: Error {
        case notADirectory
        case readingError
        case unsupportedUTType
    }

    static let readableContentTypes: [UTType] = [.xcdatamodel, .xcdatamodeld]

    var modelVersions: [String: XcodeDataModel] = [:]

    init(versions: [String: XcodeDataModel]) {
        modelVersions = versions
    }

    init(configuration: ReadConfiguration) throws {
        let package = configuration.file

        guard package.isDirectory else {
            throw PackagingError.notADirectory
        }

        guard let packageContents = package.fileWrappers else {
            assertionFailure("Directory was modified")
            throw PackagingError.readingError
        }

        var modelVersionData: [String: Data] = [:]
        switch configuration.contentType {
        case .xcdatamodeld:
            for (filename, packagedVersion) in packageContents where packagedVersion.isDirectory {
                if let contents = packagedVersion.fileWrappers?["contents"], contents.isRegularFile {
                    modelVersionData[filename] = contents.regularFileContents
                }
            }
        case .xcdatamodel:
            if let contents = packageContents["contents"], contents.isRegularFile {
                modelVersionData["Version 0"] = contents.regularFileContents
            }
        default:
            throw PackagingError.unsupportedUTType
        }

        for (version, data) in modelVersionData {
            do {
                modelVersions[version] = try decodeModelContents(data: data)
            } catch {
                print("Error decoding \(version). Error: \(error)")
            }
        }
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        fatalError("Write not supported")
    }

    // MARK: Decode XML

    enum XMLDecodingError: Swift.Error {
        case emptyDocument
    }

    private func decodeModelContents(data: Data) throws -> XcodeDataModel {
        let xmlDocument = try XMLDocument(data: data)
        guard let rootElement = xmlDocument.rootElement() else {
            throw XMLDecodingError.emptyDocument
        }

        // Properties
        let properties = XcodeDataModel.Properties(
            type: rootElement.attribute(forName: "type")?.stringValue,
            documentVersion: rootElement.attribute(forName: "documentVersion")?.stringValue,
            lastSavedToolsVersion: rootElement.attribute(forName: "lastSavedToolsVersion")?.stringValue,
            systemVersion: rootElement.attribute(forName: "systemVersion")?.stringValue,
            userDefinedModelVersionIdentifier: rootElement.attribute(forName: "userDefinedModelVersionIdentifier")?.stringValue
        )

        // Entities
        var entities: [XcodeDataModel.Entity] = []
        return XcodeDataModel(entities: entities, properties: properties)
    }
}
