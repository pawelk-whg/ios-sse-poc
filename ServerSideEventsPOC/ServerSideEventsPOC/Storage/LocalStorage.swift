//
//  LocalStorage.swift
//  SSE POC
//

import Foundation

enum StorageKeys: String {
    case baseURL
}

enum StorageError: Error {
    case unableToEncodeData
    case dataStorageError
}

protocol LocalStorage {
    func setValue<T: Encodable>(_ value: T, forKey key: String) async throws
    func getValue<T: Decodable>(forKey key: String) async -> T?
    func removeValue(forKey key: String) async throws
}
