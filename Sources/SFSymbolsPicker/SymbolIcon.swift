//
//  SwiftUIView.swift
//
//
//  Created by Alessio Rubicini on 22/10/23.
//

import SwiftUI

struct SymbolIcon: View {
    let symbolName: String

    var body: some View {
        Image(systemName: symbolName)
            .imageScale(.large)
            .contentShape(Rectangle())
    }
    
}

#Preview {
    SymbolIcon(symbolName: "beats.powerbeatspro")
}
