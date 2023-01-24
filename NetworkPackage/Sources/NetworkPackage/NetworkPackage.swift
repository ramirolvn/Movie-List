import Foundation

let apiULRString = "https://api.tvmaze.com/"

public enum HTTPMethod: String {
	case get = "GET"
	case put = "PUT"
	case post = "POST"
	case delete = "DELETE"
}

public class NetworkPackage {
	
	public static func baseRequest<T:Decodable>(urlPath: String, headerParameters: [String: String]? = nil, bodyParameters: [String: Any]? = nil, method: HTTPMethod, responseCompletion: @escaping (_ response: T?, String?) -> Void) {
		
		guard let url = URL(string: "\(apiULRString)" + urlPath) else { return }
		
		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue
		
		if let headerParameters = headerParameters {
			for param in headerParameters {
				request.addValue(param.value, forHTTPHeaderField: param.key)
			}
		}
		
		if let bodyParameters = bodyParameters,
		   let httpBody = try? JSONSerialization.data(withJSONObject: bodyParameters, options: []) {
			request.httpBody = httpBody
		}
		
		//request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		
		
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
