//
//  ContentViewModel.swift
//  SSE POC
//

import Foundation
import UIKit
import Combine

struct ContentViewState: Equatable {
    let eventsLog: String
}

protocol ContentViewModel: ObservableObject {
    var viewState: ContentViewState { get }
    var viewStatePublished: Published<ContentViewState> { get }
    var viewStatePublisher: Published<ContentViewState>.Publisher { get }

    func onViewAppeared()
    func connect()
    func disconnect()
    func clearLog()
}

final class LiveContentViewModel: ContentViewModel {
    @Published private(set) var viewState: ContentViewState = .default

    private let sseNetworkingController: SSENetworkingController
    private var events: [String] = []
    private var cancellables = Set<AnyCancellable>()

    init(
        sseNetworkingController: SSENetworkingController = LiveSSENetworkingController()
    ) {
        self.sseNetworkingController = sseNetworkingController
    }

    @MainActor func onViewAppeared() {
        sseNetworkingController.eventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                events.append(event.formattedMessage)
                composeViewState()
            }
            .store(in: &cancellables)
    }

    func connect() {
        Task {
            await sseNetworkingController.connectToServer()
        }
    }

    func disconnect() {
        sseNetworkingController.disconnectFromServer()
    }

    func clearLog() {
        events = []
        composeViewState()
    }
}

private extension LiveContentViewModel {

    func composeViewState() {
        var log = ""
        events.forEach { log.append("\($0)\n") }
        if log.isEmpty {
            log = "No events received yet"
        }
        viewState = ContentViewState(
            eventsLog: log
        )
    }
}

extension LiveContentViewModel {
    var viewStatePublished: Published<ContentViewState> {
        _viewState
    }

    var viewStatePublisher: Published<ContentViewState>.Publisher {
        $viewState
    }
}

private extension ContentViewState {

    static var `default`: ContentViewState {
        ContentViewState(
            eventsLog: "No events received yet"
        )
    }
}
