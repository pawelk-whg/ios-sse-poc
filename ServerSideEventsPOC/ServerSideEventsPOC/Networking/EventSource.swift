//
//  EventSource.swift
//  SSE POC
//

import Foundation
import LDSwiftEventSource

protocol EventSourceProtocol {
    func start()
    func stop()
}

extension EventSource: EventSourceProtocol {}

protocol EventSourceFactory {
    func makeEventSource(url: URL, handler: EventHandler) -> EventSourceProtocol
}

extension EventSourceFactory {
    func makeEventSource(url: URL = .Const.baseURL, handler: EventHandler) -> EventSourceProtocol {
        EventSource(config: .init(handler: handler, url: url))
    }
}

struct LiveEventSourceFactory: EventSourceFactory {
    func makeEventSource(url: URL, handler: EventHandler) -> EventSourceProtocol {
        EventSource(config: .init(handler: handler, url: url))
    }
}

extension URL {

    enum Const {
        static let baseURL = URL(string: "http://sse-test.wynn.dev.whg.tech:8080/test")!
    }
}
