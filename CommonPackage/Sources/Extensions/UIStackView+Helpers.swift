//
//  File.swift
//  
//
//  Created by Ramiro Lima on 24/01/23.
//

import UIKit

public extension UIStackView {
	
	func addArrangedSubviews(_ subviews: [UIView]) {
		for subview in subviews {
			addArrangedSubview(subview)
		}
	}
	
	/// Sweeter: Remove `s@objc ubview` from the view hierarchy, not just the stack arrangement.
	func removeArrangedSubviewCompletely(_ subview: UIView) {
		removeArrangedSubview(subview)
		subview.removeFromSuperview()
	}
	
	/// Sweeter: Remove all arranged subviews from the view hierarchy, not just the stack arrangement.
	func removeAllArrangedSubviewsCompletely() {
		for subview in arrangedSubviews.reversed() {
			removeArrangedSubviewCompletely(subview)
		}
	}
}
