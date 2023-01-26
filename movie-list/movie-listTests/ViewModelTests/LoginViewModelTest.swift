//
//  LoginViewModelTest.swift
//  movie-listTests
//
//  Created by Ramiro Lima on 25/01/23.
//
import XCTest
@testable import movie_list

final class LoginViewModelTest: XCTestCase {

	private var viewModel: LoginViewModelProtocol!
	
	override func setUpWithError() throws {
		viewModel = LoginViewModel()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testLoginOrCreateAccount() throws {
		viewModel.login(email: "teste@gmail.com", password: "123")
		XCTAssert(viewModel.hasUser())
	}

}
