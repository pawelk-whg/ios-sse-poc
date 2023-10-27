//
//  SettingsView.swift
//  SSE POC
//

import SwiftUI

struct SettingsView<ViewModel>: View where ViewModel: SettingsViewModel {
    @ObservedObject var viewModel: ViewModel
    @State private var newBaseURLString: String = ""

    var body: some View {
        ZStack {
            Form {
                Section(header: Text("BASE URL"), content: {
                    HStack(spacing: 10) {
                        Image(systemName: "pencil.circle.fill")
                        TextField("Enter base URL", text: $newBaseURLString)
                    }
                    HStack {
                        Spacer()
                        Button {
                            changeBaseURL()
                        } label: {
                            Text("Change base URL")
                        }
                        .disabled(!canChangeBaseURL)
                        Spacer()
                    }
                })
                .animation(.default, value: 0.5)
            }
        }
        .onAppear {
            newBaseURLString = viewModel.viewState.baseURL.absoluteString
            Task {
                await viewModel.onViewAppeared()
            }
        }
        .onChange(of: viewModel.viewState.baseURL) {
            newBaseURLString = $0.absoluteString
        }
    }
}

extension SettingsView {

    var viewState: SettingsViewState {
        viewModel.viewState
    }

    var canChangeBaseURL: Bool {
        !newBaseURLString.isEmpty && viewState.baseURL.absoluteString != newBaseURLString && URL(string: newBaseURLString) != nil
    }

    func changeBaseURL() {
        guard let newBaseURL = URL(string: newBaseURLString) else {
            return
        }
        Task {
            await viewModel.update(url: newBaseURL)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: LiveSettingsViewModel())
    }
}
