//
//  ShowListCell.swift
//  movie-list
//
//  Created by Ramiro Lima on 24/01/23.
//

import UIKit
import CommonPackage

class ShowListCell: UITableViewCell {
	
	static let className =  "ShowListCell"
	
	private lazy var showImageLabel: UIImageView = {
		let image = UIImageView()
		image.contentMode = .scaleAspectFit
		return image
	}()
	
	private lazy var titleShowLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		return label
	}()
	
	
	private func setupUI(isSerie: Bool) {
		contentView.addSubviews([
			showImageLabel,
			titleShowLabel
		])
		
		showImageLabel
			.heightTo(isSerie ? 150 : 40)
			.widthTo(isSerie ? 150 : 70)
			.leadingToSuperview(12)
			
		
		if isSerie {
			showImageLabel
				.topToSuperview(8)
				.bottomToSuperview(8)
		}
			
		
		titleShowLabel
			.leadingToTrailing(of: showImageLabel,
							   margin: 12)
			.trailingToSuperview(8)
			.centerVertical(to: showImageLabel)
	}
	
	
	func configView(isSerie: Bool, title: String, imageUrlStr: String) {
		setupUI(isSerie: isSerie)
		
		titleShowLabel.text = title
		showImageLabel.load(url: URL(string: imageUrlStr))
		
	}
}
