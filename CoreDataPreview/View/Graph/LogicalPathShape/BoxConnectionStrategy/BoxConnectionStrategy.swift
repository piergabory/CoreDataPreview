//
//  ControlPointSelector.swift
//  SwiftDiagram
//
//  Created by Pierre Gabory on 14/04/2024.
//

import SwiftUI

protocol BoxConnectionStrategy {
    typealias EdgePair = (origin: CGRectEdge, destination: CGRectEdge)
    func boxConnection(from origin: CGRect, to destination: CGRect) -> EdgePair
}

private struct BoxConnectionStrategyEnvironmentKey: EnvironmentKey {
    let strategy: BoxConnectionStrategy
    static let defaultValue = BoxConnectionStrategyEnvironmentKey(strategy: ClosestEdgeConnectionStrategy())
}

extension EnvironmentValues {
    var boxConnectionStrategy: any BoxConnectionStrategy {
        get { self[BoxConnectionStrategyEnvironmentKey.self].strategy }
        set { self[BoxConnectionStrategyEnvironmentKey.self] = BoxConnectionStrategyEnvironmentKey(strategy: newValue) }
    }
}
