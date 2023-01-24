//
//  MovieAPI.swift
//  movie-list
//
//  Created by Ramiro Lima on 23/01/23.
//

import NetworkPackage

protocol ShowAPIProtocol {
	func getMovies(
		page: String,
		completion: @escaping (_ data: [Show]?, String?) -> Void)
	func searchByName(name: String,
					  completion: @escaping ([ShowSearchable]?,
											 String?) -> Void)
}

class ShowAPI: ShowAPIProtocol {
	
	// MARK: - Initializer
	init() {}
	
	func getMovies(page: String, completion: @escaping ([Show]?, String?) -> Void) {
		NetworkPackage.baseRequest(urlPath: ShowApiPaths.getShows.getPath(page: page), method: .get, responseCompletion: completion)
	}
	
	func searchByName(name: String, completion: @escaping ([ShowSearchable]?, String?) -> Void) {
		NetworkPackage.baseRequest(urlPath: ShowApiPaths.showByName.getPath(name: name), method: .get, responseCompletion: completion)
	}
	
}
