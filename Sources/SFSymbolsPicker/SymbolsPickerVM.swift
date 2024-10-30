//
//  SymbolsPickerViewModel.swift
//
//
//  Created by Alessio Rubicini on 25/02/24.
//

import Foundation
import SwiftUI
import Combine

public class SymbolsPickerViewModel: ObservableObject {
    
    let title: String
    let searchbarLabel: String
    let autoDismiss: Bool
    private let symbolLoader: SymbolLoader = SymbolLoader()
    private var bag = Set<AnyCancellable>()

    @Published var symbols: [Symbol] = []
    @Published var searchText: String = ""

    init(
        title: String,
        searchbarLabel: String,
        autoDismiss: Bool
    ) {
        self.title = title
        self.searchbarLabel = searchbarLabel
        self.autoDismiss = autoDismiss
        self.symbols = symbolLoader.getSymbols()

        $searchText
            .removeDuplicates()
            .throttle(for: 1.0, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] query in
                self?.searchSymbols(with: query)
            }.store(in: &bag)

    }
    
    private func searchSymbols(with name: String) {
        withAnimation {
            symbols = symbolLoader.getSymbols(named: name)
        }
    }
}
