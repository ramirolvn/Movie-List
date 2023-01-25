//
//  File.swift
//  
//
//  Created by Ramiro Lima on 24/01/23.
//

import Foundation
import UIKit

public extension UIImageView {
	func load(url: URL?, placeholder: UIImage? = nil, cache: URLCache? = nil) {
		var placeholder = placeholder
		if #available(iOS 13.0, *), placeholder == nil {
			let largeConfig = UIImage.SymbolConfiguration(pointSize: 140, weight: .bold, scale: .large)
			placeholder = UIImage(systemName: "popcorn", withConfiguration: largeConfig)
		}
		
		guard let url = url else {
			self.image = placeholder
			return
		}
		let cache = cache ?? URLCache.shared
		let request = URLRequest(url: url)
		
		if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
			DispatchQueue.main.async {
				self.image = image
			}
		} else {
			self.image = placeholder
			URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
				guard let data = data, let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode, let image = UIImage(data: data) else { return }
				
				let cachedData = CachedURLResponse(response: httpResponse, data: data)
				cache.storeCachedResponse(cachedData, for: request)
				DispatchQueue.main.async {
					self?.image = image
				}
			}.resume()
		}
	}
}
