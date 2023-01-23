//
//  ViewController.swift
//  movie-list
//
//  Created by Ramiro Lima on 23/01/23.
//

import UIKit
import CommonPackage

class ViewController: UIViewController {
	
	private lazy var searchTopBar: UISearchBar = {
		let searchBar = UISearchBar()
		return searchBar
	}()
	
	private lazy var tableViewList: UITableView = {
		let tableView = UITableView()
		return tableView
	}()
	
	private lazy var tabBottomBar: UITabBar = {
		let tabBar = UITabBar()
		return tabBar
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
	}
	
	private func setupView() {
		setupUI()
		configTableView()
		configTabBar()
	}
	
	private func setupUI() {
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
		searchTopBar.placeholder = "Type the name of the serie ;)"
	}
	
	private func configTableView() {
		tableViewList.dataSource = self
		tableViewList.delegate = self
	}
	
	private func configTabBar() {
		tabBottomBar.delegate = self
		tabBottomBar.items = [ UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), tag: 0),
							   UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)]
	}
	
}

//MARK: TABLE VIEW DATASOURCE

extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		
		cell.textLabel?.text = ".red"
		
		return cell
	}
}

//MARK: TABLE VIEW DELEGATE

extension ViewController: UITableViewDelegate {
	
}


//MARK: SEARCH BAR DELEGATE

extension ViewController:  UISearchBarDelegate {
	
}

//MARK: TAB BAR DELEGATE

extension ViewController: UITabBarDelegate {
	
}
