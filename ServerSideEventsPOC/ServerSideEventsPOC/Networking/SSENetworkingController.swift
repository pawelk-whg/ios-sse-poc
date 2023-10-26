//
//  SSENetworkingController.swift
//  SSE POC
//

import Foundation
import Combine
import LDSwiftEventSource

protocol SSENetworkingController {
    var eventPublisher: AnyPublisher<SSEEvent, Never> { get }
    func connectToServer()
    func disconnectFromServer()
}

final class LiveSSENetworkingController: SSENetworkingController {
    private let url: URL
    private let factory: any EventSourceFactory
    private let eventsSubject = PassthroughSubject<SSEEvent, Never>()

    private var eventSource: EventSourceProtocol?

    var eventPublisher: AnyPublisher<SSEEvent, Never> {
        eventsSubject.eraseToAnyPublisher()
    }

    init(factory: EventSourceFactory = LiveEventSourceFactory(), url: URL = .Const.baseURL) {
        self.factory = factory
        self.url = url
    }

    func connectToServer() {
        guard eventSource == nil else { return }
        eventSource = factory.makeEventSource(url: url, handler: self)
        eventSource?.start()
    }

    func disconnectFromServer() {
        eventSource?.stop()
        eventSource = nil
    }
}

extension LiveSSENetworkingController: EventHandler {

    func onOpened() {
        eventsSubject.send(.init(id: "N/A", data: "", type: .open, timestamp: .now))
    }

    func onClosed() {
        eventsSubject.send(.init(id: "N/A", data: "", type: .close, timestamp: .now))
    }

    func onMessage(eventType: String, messageEvent: MessageEvent) {
        eventsSubject.send(
            .init(id: messageEvent.lastEventId, data: messageEvent.data, type: .message, timestamp: .now)
        )
    }

    func onComment(comment: String) {
        eventsSubject.send(.init(id: "N/A", data: comment, type: .comment, timestamp: .now))
    }

    func onError(error: Error) {
        eventsSubject.send(.init(id: "N/A", data: error.localizedDescription, type: .error, timestamp: .now))
    }
}
