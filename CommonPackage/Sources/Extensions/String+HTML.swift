//
//  File.swift
//  
//
//  Created by Ramiro Lima on 24/01/23.
//

import Foundation
extension String {
	
	var utfData: Data {
		return Data(utf8)
	}
	
	public var attributedHtmlString: NSAttributedString? {
		
		do {
			return try NSAttributedString(data: utfData, options: [
				.documentType: NSAttributedString.DocumentType.html,
				.characterEncoding: String.Encoding.utf8.rawValue
			],
										  documentAttributes: nil)
		} catch {
			print("Error:", error)
			return nil
		}
	}
}
