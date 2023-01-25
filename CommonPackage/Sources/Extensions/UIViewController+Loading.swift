//
//  File.swift
//  
//
//  Created by Ramiro Lima on 23/01/23.
//

import Foundation
import UIKit

let loadingTag = 99556

public protocol LoadingPresenting {
	/// Shows a loading view on top of some ViewControler
	func showLoading(_ color: UIColor?)
	/// Tries to hide the loadingView that is visible
	func hideLoading()
}
extension LoadingPresenting where Self: UIViewController {
	
	/// Shows a loading view on top of some ViewControler
	public func showLoading(_ color: UIColor? = nil) {
		view.showLoading(color)
	}
	
	/// Tries to hide the loadingView that is visible
	public func hideLoading() {
		view.hideLoading()
	}
}

extension UIView {
	
	/// Shows a loading view on top of some View
	public func showLoading(_ color: UIColor? = nil) {
		self.subviews.first(where: {$0.tag == loadingTag})?.removeFromSuperview()
		let activityView = UIActivityIndicatorView(style: .whiteLarge)
		activityView.tag = loadingTag
		activityView.color = color ?? .darkText
		activityView.center = self.center
		self.addSubview(activityView)
		activityView.startAnimating()
	}
	
	/// Tries to hide the loadingView that is visible
	public func hideLoading() {
		UIView.animate(withDuration: 0.25, animations: {
			DispatchQueue.main.async { [self] in
				let loadingView = self.viewWithTag(loadingTag)
				loadingView?.alpha = 0
			}
		}, completion: { _ in
			DispatchQueue.main.async {
				let loadingView = self.viewWithTag(loadingTag)
				(loadingView as? UIActivityIndicatorView)?.stopAnimating()
				loadingView?.removeFromSuperview()
			}
		})
	}
}
