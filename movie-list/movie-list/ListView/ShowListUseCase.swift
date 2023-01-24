//
//  MoviewListUseCase.swift
//  movie-list
//
//  Created by Ramiro Lima on 23/01/23.
//

import Foundation

final class ShowListUseCase {
	
	private var showAPI: ShowAPIProtocol
	private static let maxShowPerPage = 240
	
	init() {
		self.showAPI = ShowAPI()
	}
	
	func getShowList(page: Int, completion: @escaping ([Show]?, String?, Bool) -> Void) {
		let pageStr = "\(page)"
		showAPI.getMovies(page: pageStr, completion: { shows, error in
			let isLast = shows != nil && (shows?.count ?? 0 < ShowListUseCase.maxShowPerPage)
			completion(shows, error, isLast)
		})
	}
	
	func searchShowByName(name: String, completion: @escaping ([ShowSearchable]?, String?) -> Void) {
		showAPI.searchByName(name: name, completion: completion)
	}
}
