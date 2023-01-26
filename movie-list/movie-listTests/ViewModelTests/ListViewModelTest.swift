//
//  ListViewModelTest.swift
//  movie-listTests
//
//  Created by Ramiro Lima on 25/01/23.
//
import XCTest
@testable import movie_list

final class ListViewModelTest: XCTestCase {

	private var viewModel: ShowListViewModelProtocol!
	
	override func setUpWithError() throws {
		viewModel = ShowListViewModel()
		viewModel.showList.value = [Show(id: 0, name: "Test 1", image: nil, rating: nil, genres: nil, summary: "First summary", schedule: nil), Show(id: 1, name: "Test 2", image: nil, rating: nil, genres: nil, summary: "Secound summary", schedule: nil), Show(id: 3, name: "Test 3", image: nil, rating: nil, genres: nil, summary: "Third summary", schedule: nil) ]
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testnumberOfRows() throws {
		XCTAssertEqual(viewModel.showList.value.count, 3)
		XCTAssertEqual(viewModel.numberOfRows, 3)
	}
	
	func testGetShow() {
		XCTAssertEqual(viewModel.getShow(by: 0)?.id, viewModel.showList.value[0].id)
	}

}
