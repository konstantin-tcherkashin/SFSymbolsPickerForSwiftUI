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
    static let maxDistance: Float = 2

    static func searchScore(query: String, target: String) -> Float {
        guard !query.isEmpty else {
            return 1
        }
        // If the target contains the query as a substring, return true
        if target.lowercased().contains(query.lowercased()) {
            return 1
        }

        guard query.count >= 3 else { return 0 }

        var score: Float = 0

        // Otherwise, tokenize the target by words and check each word's distance to the query
        let queryWords = query.split(separator: " ").filter { $0.count < 32 }.prefix(3)
        let targetWords = target.split(separator: " ").filter { $0.count < 32 }.prefix(3)

        for queryWord in queryWords {
            for targetWord in targetWords {
                let distance = Float(String(targetWord).levenshteinDistance(to: String(queryWord)))
                if distance <= maxDistance {
                    score += 1/(max(1, distance)*10)
                }
            }
        }

        return score
    }

    static func search<T: SearchableElement>(query: String, in collection: [T]) -> [T] {
        let index = collection.map { item in
            (key: item, value: SearchUtility.searchScore(query: query, target: item.searchIndex))
        }
        return index.filter { $0.value > 0 }.sorted(by: { $0.value > $1.value }).map(\.key)
    }
}

private extension String {
    func levenshteinDistance(to target: String) -> Int {
        let source = Array(self)
        let target = Array(target)

        let (sourceCount, targetCount) = (source.count, target.count)
        var matrix = [[Int]]()

        for _ in 0...sourceCount {
            matrix.append([Int](repeating: 0, count: targetCount + 1))
        }

        for i in 0...sourceCount {
            matrix[i][0] = i
        }

        for j in 0...targetCount {
            matrix[0][j] = j
        }

        for i in 1...sourceCount {
            for j in 1...targetCount {
                let cost = source[i - 1] == target[j - 1] ? 0 : 1

                matrix[i][j] = Swift.min(
                    matrix[i - 1][j] + 1,
                    matrix[i][j - 1] + 1,
                    matrix[i - 1][j - 1] + cost
                )
            }
        }

        return matrix[sourceCount][targetCount]
    }
}
