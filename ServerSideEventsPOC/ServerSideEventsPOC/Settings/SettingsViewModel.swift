//
//  SettingsViewModel.swift
//  SSE POC
//

import Foundation
import UIKit
import Combine

struct SettingsViewState: Equatable {
    let baseURL: URL
}

protocol SettingsViewModel: ObservableObject {
    var viewState: SettingsViewState { get }
    var viewStatePublished: Published<SettingsViewState> { get }
    var viewStatePublisher: Published<SettingsViewState>.Publisher { get }

    func onViewAppeared() async
    func update(url: URL) async
}

final class LiveSettingsViewModel: SettingsViewModel {
    @Published private(set) var viewState: SettingsViewState = .default

    private let storage: LocalStorage

    init(storage: LocalStorage = UserDefaults.standard) {
        self.storage = storage
    }

    @MainActor func onViewAppeared() async {
        let url = await storage.getValue(forKey: StorageKeys.baseURL.rawValue) ?? URL.Const.baseURL
        viewState = SettingsViewState(baseURL: url)
    }

    @MainActor func update(url: URL) async {
        try? await storage.setValue(url, forKey: StorageKeys.baseURL.rawValue)
        viewState = SettingsViewState(baseURL: url)
    }
}

extension LiveSettingsViewModel {
    var viewStatePublished: Published<SettingsViewState> {
        _viewState
    }

    var viewStatePublisher: Published<SettingsViewState>.Publisher {
        $viewState
    }
}

private extension SettingsViewState {

    static var `default`: SettingsViewState {
        SettingsViewState(
            baseURL: .Const.baseURL
        )
    }
}
