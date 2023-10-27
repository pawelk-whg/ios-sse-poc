//
//  ContentView.swift
//  SSE POC
//

import SwiftUI

struct ContentView<ViewModel>: View where ViewModel: ContentViewModel {
    @ObservedObject var viewModel: ViewModel
    @State private var isConnected = false

    var body: some View {
        List {
            Section(header: makeSectionHeader()) {
                //  TODO: Replace text with a collection cells.
                Text(viewModel.viewState.eventsLog)
                    .font(.footnote)
                    .listRowSeparator(.hidden)
                    .animation(.default, value: viewModel.viewState.eventsLog)
            }
        }
        .listStyle(.grouped)
        .onAppear {
            viewModel.onViewAppeared()
        }
    }
}

private extension ContentView {

    func makeSectionHeader() -> some View {
        Button(isConnected ? "Disconnect" : "Connect") {
            if isConnected {
                viewModel.disconnect()
            } else {
                viewModel.connect()
            }
            self.isConnected.toggle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: LiveContentViewModel())
    }
}
