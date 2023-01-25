//
//  EpisodeDetailViewModel.swift
//  movie-list
//
//  Created by Ramiro Lima on 24/01/23.
//

import Foundation
protocol EpisodeDetailViewModelProtocol: AnyObject {
	var episode: Episode { get }
}
class EpisodeDetailViewModel: EpisodeDetailViewModelProtocol {
	var episode: Episode
	
	init(episode: Episode) {
		self.episode = episode
	}
}
