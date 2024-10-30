//
//  SymbolLoader.swift
//
//
//  Created by Alessio Rubicini on 31/10/23.
//

import Foundation

// This class is responsible for loading symbols from system
public class SymbolLoader {
    private final var allSymbols: [Symbol] = []

    public init() {
        self.allSymbols = getAllSymbols()
    }

    // Retrieves symbols for the current page
    public func getSymbols() -> [Symbol] {
        return allSymbols
    }

    // Retrieves symbols that start with the specified name
    public func getSymbols(named name: String) -> [Symbol] {
        SearchUtility.search(query: name, in: allSymbols)
    }

    // Loads all symbols from the plist file
    private func getAllSymbols() -> [Symbol] {
        if let bundle = Bundle(identifier: "com.apple.CoreGlyphs"),
           let resourcePath = bundle.path(forResource: "name_availability", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: resourcePath),
           let plistSymbols = plist["symbols"] as? [String: String],
           let searchIndexPlistPath = bundle.path(forResource: "symbol_search", ofType: "plist"),
           let parsedSearchIndex = NSDictionary(contentsOfFile: searchIndexPlistPath) as? [String: [String]]
        {
            return Array(plistSymbols.keys).sorted(by: {
                $1 > $0
            }).map {
                Symbol(systemIconName: $0, aliases: parsedSearchIndex[$0] ?? [])
            }
        }
        return []
    }
}
