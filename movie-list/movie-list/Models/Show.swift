import Foundation



struct Show: Codable {
	let id: Int
	let name: String
	let image: Image?
	let rating: Rating?
	let summary: String?

	enum CodingKeys: String, CodingKey {
		case id
		case name
		case image
		case rating
		case summary
	}
}

struct Image: Codable {
	let medium: String?
	let original: String?

	enum CodingKeys: String, CodingKey {
		case medium
		case original
	}
}

struct Rating: Codable {
	let average: Double?

	enum CodingKeys: String, CodingKey {
		case average
	}
}
