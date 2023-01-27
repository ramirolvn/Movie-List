//
//  ShowListViewModel.swift
//  movie-list
//
//  Created by Ramiro Lima on 23/01/23.
//

import Foundation
import CommonPackage

protocol ShowListViewModelProtocol: AnyObject {
	var numberOfRows: Int { get }
	var showList: Observable<[Show]> { get }
	var showErrorAlertPopUp: Observable<String> { get }
	var isLoadingView: Observable<Bool> { get }
	var filtredShows: Observable<[Show]> { get }
	var reloadFavoriteShowIndex: Observable<Int?> { get }
	var isFavoriteSelected: Observable<Bool> { get }
	
	func getShowList()
	func searchByName(name: String)
	func getShow(by index: Int) -> Show?
	func clearSearches()
	func favoriteShow(id: Int)
	func disfavorShow(id: Int)
	func getShowFavoriteStatus(by id: Int) -> Bool
}

class ShowListViewModel: ShowListViewModelProtocol {
	var showList: Observable<[Show]> = Observable([])
	var filtredShows: Observable<[Show]> = Observable([])
	var reloadFavoriteShowIndex: Observable<Int?> = Observable(nil)
	var showErrorAlertPopUp: Observable<String> = Observable("")
	var isLoadingView: Observable<Bool> = Observable(false)
	var isFavoriteSelected: Observable<Bool> = Observable(false)
	var numberOfRows: Int {
		guard isFiltering else { return showList.value.count }
		return filtredShows.value.count
	}
	
	var isFiltering: Bool {
		return filtredShows.value.count > 0
	}
	
	private var page = 0
	private var isLast = false
	
	init() { }
	
	
	func getShowList() {
		guard !isLast, !isFiltering else { return }
		isLoadingView.value = true
		ShowListUseCase().getShowList(page: page, completion: { shows, error, isLast in
			self.isLoadingView.value = false
			self.isLast = isLast
			
			if let errorStr = error {
				self.showErrorAlertPopUp.value = errorStr
				return
			}
			if let shows = shows {
				self.showList.value+=shows
				return
			}
			self.showErrorAlertPopUp.value = "Erro desconhecido!"
		})
	}
	
	func searchByName(name: String) {
		guard !name.isEmpty else { return }
		isLoadingView.value = true
		ShowListUseCase().searchShowByName(name: name, completion: { shows, error in
			self.isLoadingView.value = false
			
			if let errorStr = error {
				self.showErrorAlertPopUp.value = errorStr
				return
			}
			if let shows = shows {
				self.filtredShows.value = shows
				return
			}
			self.showErrorAlertPopUp.value = "Erro desconhecido!"
			
		})
	}
	
	func clearSearches() {
		page = 0
		isLast = false
		filtredShows.value = []
		showList.value = []
		getShowList()
		
	}
	
	func getShow(by index: Int) -> Show? {
		if filtredShows.value.count > 0,
		   filtredShows.value.count > index {
			return filtredShows.value[index]
		}
		guard showList.value.count > index else { return nil }
		return showList.value[index]
	}
	
	func getShowFavoriteStatus(by id: Int) -> Bool {
		ShowRealm.findShow(by: id) != nil
	}
	
	func favoriteShow(id: Int) {
		guard let show = getShow(byId: id),
			  ShowRealm.saveShow(id: show.id, name: show.name, imageMedium: show.image?.medium, imageOriginal: show.image?.original , genres: show.genres, summary: show.summary, scheduleTime: show.schedule?.time, scheduleDays: show.schedule?.days)
		else {
			showErrorAlertPopUp.value = "Sorry, we cound't favorite your show"
			return
		}
		reloadFavoriteShowIndex.value = getIndex(for: show)
	}
	
	func disfavorShow(id: Int) {
		
		guard let show = getShow(byId: id),
			  ShowRealm.deleteShow(by: id)
		else {
			showErrorAlertPopUp.value = "Sorry, we cound't favorite your show"
			return
		}
		reloadFavoriteShowIndex.value = getIndex(for: show)
	}
	
	private func getShow(byId: Int) -> Show? {
		if filtredShows.value.count > 0 {
			return filtredShows.value.first(where: {$0.id == byId})
		}
		return showList.value.first(where: {$0.id == byId})
	}
	
	private func getIndex(for show: Show) -> Int? {
		if filtredShows.value.count > 0 {
			return filtredShows.value.firstIndex(where: {$0.id == show.id})
		}
		return showList.value.firstIndex(where: {$0.id == show.id})
	}
}

