//
//  ViewController.swift
//  movie-list
//
//  Created by Ramiro Lima on 23/01/23.
//

import UIKit
import CommonPackage

class ShowListView: BaseViewController, LoadingPresenting {
	
	private lazy var searchTopBar: UISearchBar = {
		let searchBar = UISearchBar()
		return searchBar
	}()
	
	private lazy var tableViewList: UITableView = {
		let tableView = UITableView()
		tableView.allowsSelection = true
		return tableView
	}()
	
	private lazy var tabBottomBar: UITabBar = {
		let tabBar = UITabBar()
		return tabBar
	}()
	
	private var viewModel: ShowListViewModelProtocol = ShowListViewModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		viewModel.getShowList()
	}
	
	private func setupView() {
		setupUI()
		configSearchBar()
		configTableView()
		configTabBar()
		setupBindUI()
	}
	
	private func setupUI() {
		title = "Show List"
		
		view.addSubviews([searchTopBar,tableViewList,tabBottomBar])
		
		searchTopBar
			.topToSuperview(toSafeArea: true)
			.leadingToSuperview()
			.trailingToSuperview()
			.heightTo(50)
		
		tableViewList
			.topToBottom(of: searchTopBar)
			.leadingToSuperview()
			.trailingToSuperview()
		
		tabBottomBar
			.topToBottom(of: tableViewList)
			.leadingToSuperview()
			.trailingToSuperview()
			.heightTo(50)
			.bottomToSuperview(toSafeArea: true)
	}
	
	private func configSearchBar() {
		searchTopBar.delegate = self
		searchTopBar.tintColor = .darkText
		searchTopBar.placeholder = "Type the name of the serie ;)"
	}
	
	private func configTableView() {
		tableViewList.dataSource = self
		tableViewList.delegate = self
		tableViewList.register(ShowListCell.self, forCellReuseIdentifier: ShowListCell.className)
	}
	
	private func configTabBar() {
		tabBottomBar.delegate = self
		tabBottomBar.items = [ UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 0),
							   UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), tag: 1)]
		tabBottomBar.selectedItem = tabBottomBar.items?.first
	}
	
	private func setupBindUI() {
		viewModel.showList.addObserver({[weak self] shows in
			guard let self = self,
				  !shows.isEmpty else { return }
			DispatchQueue.main.async {
				self.tableViewList.reloadData()
			}
		})
		
		viewModel.filtredShows.addObserver({[weak self] shows in
			guard let self = self,
				  !shows.isEmpty else { return }
			DispatchQueue.main.async {
				self.tableViewList.reloadData()
			}
		})
		
		viewModel.isLoadingView.addObserver({[weak self] isLoading in
			guard let self = self,
				  isLoading
			else {
				DispatchQueue.main.async {
					self?.hideLoading()
				}
				return
			}
			DispatchQueue.main.async {
				self.showLoading()
			}
		})
		
		viewModel.showErrorAlertPopUp.addObserver({ [weak self] alertError in
			DispatchQueue.main.async {
				guard let self = self, !alertError.isEmpty else { return }
				let errorAlert = UIAlertController(title: "Error", message: alertError, preferredStyle: UIAlertController.Style.alert)
				
				errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
				}))
				
				self.present(errorAlert, animated: true, completion: nil)
			}
		})
	}
	
	private func dismissKeyboard() {
		view.endEditing(true)
	}
	
}

//MARK: TABLE VIEW DATASOURCE

extension ShowListView: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.numberOfRows
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: ShowListCell.className) as? ShowListCell,
			  let show = viewModel.getShow(by: indexPath.item) else {
			return UITableViewCell()
		}
		
		cell.configView(isSerie: true, title: show.name, imageUrlStr: show.image?.medium ?? "")

		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let lastSectionIndex = tableView.numberOfSections - 1
		let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
		if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
			viewModel.getShowList()
		}
	}
}

//MARK: TABLE VIEW DELEGATE

extension ShowListView: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let showSelected = viewModel.getShow(by: indexPath.item) else { return }
		let detailShowView = ShowDetailView()
		detailShowView.viewModel =  ShowDetailViewModel(show: showSelected)
		self.navigationController?.pushViewController(detailShowView, animated: true)
	}
}


//MARK: SEARCH BAR DELEGATE

extension ShowListView:  UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchText.isEmpty {
			viewModel.clearSearches()
			return
		}
		viewModel.searchByName(name: searchBar.text ?? "")
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		dismissKeyboard()
	}
}

//MARK: TAB BAR DELEGATE

extension ShowListView: UITabBarDelegate {
	
}
