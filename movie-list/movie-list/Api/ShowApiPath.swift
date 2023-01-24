//
//  ShowApiPath.swift
//  movie-list
//
//  Created by Ramiro Lima on 23/01/23.
//

import Foundation
enum ShowApiPaths: String {
	case getShows
	case showsSeasons
	case showByName
	
	func getPath(with showID: String = "", name: String = "", page: String = "") -> String {
		switch self {
		case .getShows:
			return "shows?page="+page
		case .showsSeasons:
			return "/shows/\(showID)/seasons"
		case .showByName:
			return "search/shows?q="+name
		}
		
	}
}
