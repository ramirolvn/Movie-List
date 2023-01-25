//
//  File.swift
//  
//
//  Created by Ramiro Lima on 24/01/23.
//

import Foundation
import UIKit

open class BaseViewController: UIViewController {
	
	public static var defaultColors: [CGColor] = [UIColor.white.cgColor, UIColor.gray.cgColor]
	
	private let gradientLayer: CAGradientLayer = {
		let gradient = CAGradientLayer()
		gradient.colors = defaultColors
		gradient.startPoint = CGPoint(x: 0, y: 0)
		gradient.endPoint = CGPoint(x: 1, y: 1)
		return gradient
	}()
	
	override open func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		gradientLayer.frame = view.bounds
	}
	
	override open func viewDidLoad() {
		super.viewDidLoad()
		
		view.layer.insertSublayer(gradientLayer, at: 0)
	}
}
