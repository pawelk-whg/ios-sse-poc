//
//  SSEEvent.swift
//  SSE POC
//

import Foundation

struct SSEEvent: Equatable {
    let id: String
    let data: String
    let type: EventType
    let timestamp: Date
}

extension SSEEvent {

    enum EventType: String {
        case open
        case close
        case message
        case comment
        case error
    }

    var formattedMessage: String {
        """
        > Message: \(type.rawValue.capitalized), received: \(formattedDate(timestamp))
        > Id: \(id.orNA), data: \(data.orNA)
        -------------------------------------------------
        """
    }
}

private extension String {

    var orNA: String {
        isEmpty ? "N/A" : self
    }
}

private extension SSEEvent {

    func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM HH:mm:sss"
        return formatter.string(from: date)
    }
}
