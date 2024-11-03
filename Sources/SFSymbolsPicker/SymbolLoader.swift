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
        if
            let bundle = Bundle(identifier: "com.apple.CoreGlyphs"),
            let resourcePath = bundle.path(forResource: "name_availability", ofType: "plist"),
            let plist = NSDictionary(contentsOfFile: resourcePath),
            let plistSymbols = plist["symbols"] as? [String: String],
            let searchIndexPlistPath = bundle.path(forResource: "symbol_search", ofType: "plist"),
            let parsedSearchIndex = NSDictionary(contentsOfFile: searchIndexPlistPath) as? [String: [String]],
            let symbolOrderPlistURL = bundle.url(forResource: "symbol_order", withExtension: "plist"),
            let parsedSymbolOrder = NSArray(contentsOf: symbolOrderPlistURL) as? [String]
        {

            // Create a lookup dictionary for order indices
            let orderLookup = Dictionary(uniqueKeysWithValues: parsedSymbolOrder.enumerated().map { ($1, $0) })

            // Sort symbols based on the precomputed order indices
            return Array(plistSymbols.keys).sorted {
                (orderLookup[$0] ?? Int.max) < (orderLookup[$1] ?? Int.max)
            }.map {
                Symbol(systemIconName: $0, aliases: parsedSearchIndex[$0] ?? [])
            }
        }
        return []
    }
}
