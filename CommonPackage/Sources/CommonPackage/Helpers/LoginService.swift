//
//  File.swift
//  
//
//  Created by Ramiro Lima on 25/01/23.
//

import Foundation
import KeychainSwift


public struct LoginService {
	private static let service = "com.example.app"
	
	public static func saveUser(email: String, and password: String) -> Bool {
		let keychain = KeychainSwift()
		return keychain.set(email+password, forKey: "user")
		
	}
	
	public static func login(with email: String, and password: String) -> Bool {
		let keychain = KeychainSwift()
		
		guard let emailAndPassword = keychain.get("user"),
			  emailAndPassword == email+password else { return false }
		return true
	}
	
	public static func logout() -> Bool {
		let keychain = KeychainSwift()
		let databaseDelete = DatabaseService.deleteAllOjects()
		return keychain.clear() && databaseDelete
	}
	
	public static func loginByFaceID() {
		let keychain = KeychainSwift()
		keychain.set(true, forKey: "faceID")
	}
	
	public static func hasFaceID() -> Bool {
		let keychain = KeychainSwift()
		return (keychain.get("faceID") != nil) == true
	}
	
	public static func hasUser() -> Bool {
		let keychain = KeychainSwift()
		
		return keychain.get("user") != nil
	}
	
}
