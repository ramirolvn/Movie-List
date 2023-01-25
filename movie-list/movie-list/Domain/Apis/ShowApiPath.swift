//
//  ShowApiPath.swift
//  movie-list
//
//  Created by Ramiro Lima on 23/01/23.
//

import Foundation
enum ShowApiPaths: String {
	case getShows
	case showEpisodes
	case showByName
	
	func getPath(with showID: String = "") -> String {
		switch self {
		case .getShows:
			return "shows"
		case .showEpisodes:
			return "shows/\(showID)/episodes"
		case .showByName:
			return "search/shows"
		}
		
	}
}
