//
//  UserDefaults+LocalStorage.swift
//  SSE POC
//

import Foundation

extension UserDefaults: LocalStorage {

    func setValue<T: Encodable>(_ value: T, forKey key: String) async throws {
        guard let encoded = try? JSONEncoder().encode(value) else {
            throw StorageError.unableToEncodeData
        }
        set(encoded, forKey: key)
    }

    func getValue<T: Decodable>(forKey key: String) async -> T? {
        guard let data = data(forKey: key) else {
            return nil
        }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    func removeValue(forKey key: String) async throws {
        removeObject(forKey: key)
    }
}
