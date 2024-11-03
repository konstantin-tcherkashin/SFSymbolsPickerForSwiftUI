//
//  Symbol.swift
//  SFSymbolsPicker
//
//  Created by Константин on 10/30/24.
//

import Foundation

public struct Symbol: Sendable {
    public let systemIconName: String
    public let aliases: [String]
}

extension Symbol: SearchableElement {
    var searchIndex: String {
        let iconNameParts = systemIconName.split(separator: ".").map { String($0) }
        return (iconNameParts + aliases).joined(separator: " ")
    }
}
