//
//  EpisodeUseCase.swift
//  movie-list
//
//  Created by Ramiro Lima on 24/01/23.
//

import Foundation

final class EpisodeUseCase {
	
	private var showAPI: ShowAPIProtocol
	
	init() {
		self.showAPI = ShowAPI()
	}
	
	func getEpisodes(by showId: Int, completion: @escaping ([Episode]?, String?) -> Void) {
		showAPI.getEpisodes(by: "\(showId)", completion: completion)
	}
}
