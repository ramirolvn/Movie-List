//
//  ShowDetailViewModel.swift
//  movie-list
//
//  Created by Ramiro Lima on 24/01/23.
//

import Foundation
import CommonPackage

protocol ShowDetailViewModelProtocol: AnyObject {
	var show: Show { get }
	var episodes: Observable<[Episode]?> { get }
	var isLoadingView: Observable<Bool> { get }
	var showErrorAlertPopUp: Observable<String?> { get }
	var seasons: [Int] { get }
	var seasonsCount: Int { get }
	
	func getEpisodes()
	func getEpisodesCountBy(season id: Int) -> Int
	func getEpisodeBy(index: Int, and section: Int) -> Episode
}

class ShowDetailViewModel: ShowDetailViewModelProtocol {
	var show: Show
	var episodes: Observable<[Episode]?> = Observable(nil)
	var isLoadingView: Observable<Bool> = Observable(false)
	var showErrorAlertPopUp: Observable<String?> = Observable(nil)
	
	var seasons: [Int] { Array(Set(episodes.value.map({$0.map({$0.season})}) ?? [])).sorted()
	}
	
	var seasonsCount: Int {
		seasons.count
	}
	
	init(show: Show) {
		self.show = show
	}
	
	func getEpisodes() {
		isLoadingView.value = true
		
		EpisodeUseCase().getEpisodes(by: show.id, completion: {
			episodes, error in
			self.isLoadingView.value = false
			self.episodes.value = episodes
			self.showErrorAlertPopUp.value = error
		})
	}
	
	func getEpisodesCountBy(season id: Int) -> Int {
		getEpisodesBy(season: id).count
	}
	
	func getEpisodeBy(index: Int, and section: Int) -> Episode {
		return getEpisodesBy(season: section)[index]
	}
	
	private func getEpisodesBy(season id: Int) -> [Episode] {
		guard seasons.count > id else { return [] }
		return episodes.value?.filter({$0.season == seasons[id]}) ?? []
	}
}


