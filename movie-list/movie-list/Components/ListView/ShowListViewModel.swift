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
	
	func getShowList()
	func searchByName(name: String)
	func getShow(by index: Int) -> Show?
	func clearSearches()
}

class ShowListViewModel: ShowListViewModelProtocol {
	var showList: Observable<[Show]> = Observable([])
	var filtredShows: Observable<[Show]> = Observable([])
	var showErrorAlertPopUp: Observable<String> = Observable("")
	var isLoadingView: Observable<Bool> = Observable(false)
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
}

