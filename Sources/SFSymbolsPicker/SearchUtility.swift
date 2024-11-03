//
//  File.swift
//  SFSymbolsPicker
//
//  Created by Константин on 10/30/24.
//

import Foundation

protocol SearchableElement {
    var searchIndex: String { get }
}

final class SearchUtility {
    static let maxDistance: Float = 2.0

    static func searchScore(query: String, target: String) -> Float {
        guard !query.isEmpty else { return 1.0 }
        guard query.count >= 3 else { return 0.0 }

        var score: Float = 0.0
        let queryWords = query.split(separator: " ")
        let targetWords = target.split(separator: " ")

        for queryWord in queryWords {
            for targetWord in targetWords {
                let distance = Float(String(targetWord).levenshteinDistance(to: String(queryWord)))
                if distance <= maxDistance {
                    score += max(0.1, 1 / (distance + 1))
                }
            }
        }

        // Boost score based on exact substring match, scaled by match length
        if let range = target.lowercased().range(of: query.lowercased()) {
            let matchedSubstring = target[range]
            let matchLengthBoost = Float(matchedSubstring.count) / Float(target.count)
            score += matchLengthBoost * 0.5
        }

        return score
    }

    static func search<T: SearchableElement>(query: String, in collection: [T]) -> [T] {
        guard query.trimmingCharacters(in: .whitespacesAndNewlines).count > 1 else { return collection }
        let indexedCollection = collection.map { item in
            (key: item, value: searchScore(query: query, target: item.searchIndex))
        }
        return indexedCollection.filter { $0.value >= 0.1 }.sorted(by: { $0.value > $1.value }).map(\.key)
    }
}

private extension String {
    func levenshteinDistance(to target: String) -> Int {
        let (source, target) = (Array(self), Array(target))
        var previousRow = Array(0...target.count)
        var currentRow = [Int](repeating: 0, count: target.count + 1)

        for (i, sourceChar) in source.enumerated() {
            currentRow[0] = i + 1
            for (j, targetChar) in target.enumerated() {
                let cost = sourceChar == targetChar ? 0 : 1
                currentRow[j + 1] = Swift.min(
                    previousRow[j + 1] + 1,
                    currentRow[j] + 1,
                    previousRow[j] + cost
                )
            }
            previousRow = currentRow
        }
        return previousRow[target.count]
    }
}
