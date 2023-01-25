import Foundation

let apiULRString = "https://api.tvmaze.com/"

public enum HTTPMethod: String {
	case get = "GET"
	case put = "PUT"
	case post = "POST"
	case delete = "DELETE"
}

public class NetworkPackage {
	
	public static func baseRequest<T:Decodable>(urlPath: String, queryParameters: [String: String]? = nil, bodyParameters: [String: Any]? = nil, method: HTTPMethod, responseCompletion: @escaping (_ response: T?, String?) -> Void) {
		
		guard var urlComponents = URLComponents(string: "\(apiULRString)" + urlPath) else {
			responseCompletion(nil, "Request error, please contact me: ramirolvn@hotmail.com")
			return
		}
		
		var queryItems = [URLQueryItem]()
		
		if let queryParameters = queryParameters {
			for (key, value) in queryParameters {
				queryItems.append(URLQueryItem(name: key, value: value))
			}
		}
		urlComponents.queryItems = queryItems
		guard let url = urlComponents.url else {
			responseCompletion(nil, "Request error, please contact me: ramirolvn@hotmail.com")
			return
		}
		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue
		
		
		
		if let bodyParameters = bodyParameters,
		   let httpBody = try? JSONSerialization.data(withJSONObject: bodyParameters, options: []) {
			request.httpBody = httpBody
		}
		
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		
		
		let session = URLSession.shared
		session.dataTask(with: request) { (data, response, error) in
			if let response = response {
				print(response)
			}
			
			if let data = data {
				do {
					responseCompletion(try? JSONDecoder().decode(T.self, from: data), nil)
					return
				}
			}
			responseCompletion(nil, "Parse Error, Please send me a Email: ramirolvn@hotmail.com")
		}.resume()
		
	}
	
	
	
}
