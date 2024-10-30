//
//  SwiftUIView.swift
//
//
//  Created by Alessio Rubicini on 22/10/23.
//

import SwiftUI

public struct SymbolsPicker<Content: View>: View {

    @Binding var selection: String
    @ObservedObject var vm: SymbolsPickerViewModel
    @Environment(\.presentationMode) var presentationMode
    let closeButtonView: Content

    /// Initialize the SymbolsPicker view
    /// - Parameters:
    ///   - selection: binding to the selected icon name.
    ///   - title: navigation title for the view.
    ///   - searchLabel: label for the search bar. Set to 'Search...' by default.
    ///   - autoDismiss: if true the view automatically dismisses itself when the symbols is selected.
    ///   - closeButton: a custom view for the picker close button. Set to 'Image(systemName: "xmark.circle")' by default.

    public init(selection: Binding<String>, title: String, searchLabel: String = "Search...", autoDismiss: Bool = false, @ViewBuilder closeButton: () -> Content = { Image(systemName: "xmark.circle") }) {
        self._selection = selection
        self.vm = SymbolsPickerViewModel(title: title, searchbarLabel: searchLabel, autoDismiss: autoDismiss)
        self.closeButtonView = closeButton()
    }

    @ViewBuilder
    public var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                LazyVGrid(
                    columns: [
                        GridItem(),
                        GridItem(),
                        GridItem(),
                        GridItem()
                    ], spacing: 20
                ) {
                    ForEach(vm.symbols, id: \.systemIconName) { symbol in
                        SymbolIcon(
                            symbolName: symbol.systemIconName
                        )
                        .onTapGesture {
                            withAnimation {
                                self.selection = symbol.systemIconName
                            }
                        }
                    }
                }
            }
            .navigationTitle(vm.title)
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        closeButtonView
                    }
                }
            }
            .padding(5)
            .searchable(text: $vm.searchText, prompt: vm.searchbarLabel)
        }
        .onChange(of: selection) { newValue in
            if(vm.autoDismiss) {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }

}

#Preview {
    SymbolsPicker(selection: .constant("beats.powerbeatspro"), title: "Pick a symbol", autoDismiss: true)
}
