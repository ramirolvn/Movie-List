//
//  LoginViewModel.swift
//  movie-list
//
//  Created by Ramiro Lima on 25/01/23.
//

import Foundation
import CommonPackage
import LocalAuthentication

protocol LoginViewModelProtocol: AnyObject {
	var loginButtonTitle: String { get }
	var showErrorAlertPopUp: Observable<String?> { get }
	var logged: Observable<Bool?> { get }
	var isLoadingView: Observable<Bool?> { get }
	var canGoToListView: Observable<Bool?> { get }
	var canRegisterBiometric: Bool { get }
	
	func login(email: String, password: String)
	func hasUser() -> Bool
	func authenticate()
}

class LoginViewModel: LoginViewModelProtocol {
	var showErrorAlertPopUp: Observable<String?> = Observable(nil)
	var logged: Observable<Bool?> = Observable(nil)
	var isLoadingView: Observable<Bool?> = Observable(nil)
	var canGoToListView: Observable<Bool?> = Observable(nil)
	
	var loginButtonTitle: String {
		return hasUser() ? "Login" : "Create Account"
	}
	
	var canRegisterBiometric: Bool {
		return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
	}
	
	private let context = LAContext()
	private var error: NSError? = nil
	
	init() {
		
	}
	
	func hasUser() -> Bool {
		LoginService.hasUser()
	}
	
	func login(email: String, password: String) {
		guard !email.isEmpty, !password.isEmpty, isValidEmail(email) else {
			showErrorAlertPopUp.value = "Please fill email with a valid email and fill password"
			return
		}
		
		if hasUser() {
			if LoginService.login(with: email, and: password) {
				logged.value = true
				return
			}
			showErrorAlertPopUp.value = "Wrong email or password"
		}else if LoginService.saveUser(email: email, and: password) {
			logged.value = true
			return
		}else {
			showErrorAlertPopUp.value = "Error save user"
		}
	}
	
	func authenticate() {
		isLoadingView.value = true
		if canRegisterBiometric {
			let reason = "Identify yourself!"
			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
								   localizedReason: reason) {
				[weak self] success, authenticationError in
				DispatchQueue.main.async {[weak self] in
					guard success, self?.error == nil else {
						self?.isLoadingView.value = false
						self?.canGoToListView.value = true
						return
					}
					self?.isLoadingView.value = false
					LoginService.loginByFaceID()
					self?.canGoToListView.value = true
				}
			}
		} else {
			canGoToListView.value = true
		}
	}
	
	
	private func isValidEmail(_ email: String) -> Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		
		let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailPred.evaluate(with: email)
	}
	
	
}
