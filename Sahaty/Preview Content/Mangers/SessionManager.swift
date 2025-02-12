//
//  SessionManager.swift
//  Sahaty
//
//  Created by mido mj on 1/14/25.
//


import Foundation

class SessionManager {
    static let shared = SessionManager() // Singleton instance
    
    private let userDefaults = UserDefaults.standard
    private let keychain = KeychainManager.shared
    
    // User-related keys
    private let tokenKey = "userToken"
    private let userTypeKey = "userType"
    private let userDataKey = "userData" // Stores user profile data
    
    
    // MARK: - Save Session
    func saveSession(token: String, userType: UsersType, userData: [String: Any]) {
        // Save token in Keychain
     let _ = keychain.saveToken(token)
        
        // Save user type and data in UserDefaults
        userDefaults.set(userType.rawValue, forKey: userTypeKey)
        if let userData = try? JSONSerialization.data(withJSONObject: userData) {
            userDefaults.set(userData, forKey: userDataKey)
        }
    }
    
    // MARK: - Retrieve Session
    func isUserLoggedIn() -> Bool {
        return keychain.getToken() != nil
    }
    
    func getUserType() -> UsersType? {
        if let userTypeRaw = userDefaults.string(forKey: userTypeKey) {
            return UsersType(rawValue: userTypeRaw)
        }
        return nil
    }
    
    func getUserData() -> [String: Any]? {
        if let userData = userDefaults.data(forKey: userDataKey),
           let json = try? JSONSerialization.jsonObject(with: userData, options: []) as? [String: Any] {
            return json
        }
        return nil
    }
    
    // MARK: - Destroy Session
    func clearSession() {
        // Remove token from Keychain
     let _ = keychain.deleteToken(forKey: "BearerToken")
        
        // Remove user data from UserDefaults
        userDefaults.removeObject(forKey: userTypeKey)
        userDefaults.removeObject(forKey: userDataKey)
    }
}
