//
//  Keychain.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Security
import Foundation

@propertyWrapper
public struct Keychain<T> where T: Codable {
    let service: KeychainHelper.ServiceKey
    let account: KeychainHelper.AccountKey
    
    /// Initialize with a service key and optional account key
    /// - Parameters:
    ///   - service: The service key identifying what kind of data is being stored
    ///   - account: The account key, defaults to .swiss
    public init(
        service: KeychainHelper.ServiceKey,
        account: KeychainHelper.AccountKey = .oauth
    ) {
        self.service = service
        self.account = account
    }

    public var wrappedValue: T? {
        get {
            return KeychainHelper.read(service: service, account: account)
        }
        set {
            if let newValue {
                try? KeychainHelper.save(newValue, service: service, account: account)
            } else {
                KeychainHelper.delete(service: service, account: account)
            }
        }
    }
}

public class KeychainHelper {
    public enum ServiceKey: String, CaseIterable {
        case userInfo = "user-info"
        case userName = "user-name"
        case userPassword = "user-password"
        case sessionId = "session-id"
        case touchpointsToken = "touchpoints-token"
        case userToken = "user-token"
    }
    
    public enum AccountKey: String {
        case oauth
    }
    
    public enum KeychainError: Error, LocalizedError {
        case saveFailure(OSStatus)
        case readFailure(OSStatus)
        case deleteFailure(OSStatus)
        case itemNotFound
        case encodingError
        case decodingError
        
        public var errorDescription: String? {
            switch self {
            case .saveFailure(let status):
                return "Failed to save item to keychain: \(status)"
            case .readFailure(let status):
                return "Failed to read item from keychain: \(status)"
            case .deleteFailure(let status):
                return "Failed to delete item from keychain: \(status)"
            case .itemNotFound:
                return "Item not found in keychain"
            case .encodingError:
                return "Failed to encode item for keychain storage"
            case .decodingError:
                return "Failed to decode item from keychain"
            }
        }
    }

    /// Saves a Codable item to the keychain
    /// - Parameters:
    ///   - item: Item to save
    ///   - service: Service key
    ///   - account: Account key
    /// - Throws: KeychainError if saving fails
    public static func save<T: Codable>(
        _ item: T,
        service: ServiceKey,
        account: AccountKey = .oauth
    ) throws {
        do {
            let data = try JSONEncoder().encode(item)
            try save(data, service: service, account: account)
        } catch let error as KeychainError {
            throw error
        } catch {
            throw KeychainError.encodingError
        }
    }
    
    /// Saves raw data to the keychain
    /// - Parameters:
    ///   - data: Data to save
    ///   - service: Service key
    ///   - account: Account key
    /// - Throws: KeychainError if saving fails
    public static func save(
        _ data: Data,
        service: ServiceKey,
        account: AccountKey = .oauth
    ) throws {
        // Create query for checking if item exists
        let query = [
            kSecAttrService: service.rawValue,
            kSecAttrAccount: account.rawValue,
            kSecClass: kSecClassGenericPassword
        ] as [CFString: Any] as CFDictionary
        
        // Try to delete any existing item
        SecItemDelete(query)
        
        // Create query to add the item
        let addQuery = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service.rawValue,
            kSecAttrAccount: account.rawValue
        ] as [CFString: Any] as CFDictionary
        
        // Add the item to keychain
        let status = SecItemAdd(addQuery, nil)
        
        guard status == errSecSuccess else {
            throw KeychainError.saveFailure(status)
        }
    }

    /// Reads a Codable item from the keychain
    /// - Parameters:
    ///   - service: Service key
    ///   - account: Account key
    ///   - type: Type to decode to
    /// - Returns: Decoded item or nil if not found
    public static func read<T: Codable>(
        service: ServiceKey,
        account: AccountKey = .oauth,
        type: T.Type = T.self
    ) -> T? {
        do {
            guard let data = try read(service: service, account: account) else {
                return nil
            }
            
            return try JSONDecoder().decode(type, from: data)
        } catch {
            return nil
        }
    }
    
    /// Reads raw data from the keychain
    /// - Parameters:
    ///   - service: Service key
    ///   - account: Account key
    /// - Returns: Data if found, nil otherwise
    /// - Throws: KeychainError if reading fails
    public static func read(
        service: ServiceKey,
        account: AccountKey = .oauth
    ) throws -> Data? {
        let query = [
            kSecAttrService: service.rawValue,
            kSecAttrAccount: account.rawValue,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as [CFString: Any] as CFDictionary
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        
        switch status {
        case errSecSuccess:
            return result as? Data
        case errSecItemNotFound:
            return nil
        default:
            throw KeychainError.readFailure(status)
        }
    }
    
    /// Deletes an item from the keychain
    /// - Parameters:
    ///   - service: Service key
    ///   - account: Account key
    /// - Returns: True if deleted or not found, false if deletion failed
    @discardableResult
    public static func delete(
        service: ServiceKey,
        account: AccountKey = .oauth
    ) -> Bool {
        let query = [
            kSecAttrService: service.rawValue,
            kSecAttrAccount: account.rawValue,
            kSecClass: kSecClassGenericPassword
        ] as [CFString: Any] as CFDictionary
        
        let status = SecItemDelete(query)
        return status == errSecSuccess || status == errSecItemNotFound
    }
    
    /// Clears all items managed by this helper
    /// - Returns: True if all items were deleted successfully
    @discardableResult
    public static func clear() -> Bool {
        var allSucceeded = true
        
        for service in ServiceKey.allCases {
            let succeeded = delete(service: service)
            if !succeeded {
                allSucceeded = false
            }
        }
        
        return allSucceeded
    }
}
