//
//  Episode.swift
//  movie-list
//
//  Created by Ramiro Lima on 24/01/23.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let episodes = try? JSONDecoder().decode(Episodes.self, from: jsonData)

import Foundation

// MARK: - Episode
struct Episode: Codable {
	let id: Int
	let url: String
	let name: String
	let season, number: Int
	let image: Image?
	let summary: String
}


