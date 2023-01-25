import Foundation

struct Show: Codable {
	let id: Int
	let name: String
	let image: Image?
	let rating: Rating?
	let genres: [String]?
	let summary: String?
	let schedule: Schedule?

	enum CodingKeys: String, CodingKey {
		case id
		case name
		case image
		case rating
		case genres
		case summary
		case schedule
	}
}

struct Image: Codable {
	let medium: String?
	let original: String?
}

struct Rating: Codable {
	let average: Double?
}

struct Schedule: Codable {
	let time: String
	let days: [String]
}
