//
//  ShowListCell.swift
//  movie-list
//
//  Created by Ramiro Lima on 24/01/23.
//

import UIKit
import CommonPackage

protocol ShowListCellOutput: AnyObject {
	func favoriteClicked(isFavorited: Bool, and showID: Int)
}

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
	
	private lazy var favoriteButton: UIButton = {
		let button = UIButton()
		button.tintColor = .darkText
		button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
		return button
	}()
	
	private var isFavorited = false
	private var showID: Int?
	private var outputProtocol: ShowListCellOutput?
	
	
	
	private func setupUI(isSerie: Bool, isFavorited: Bool) {
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
			
			contentView.addSubviews([favoriteButton])
			
			favoriteButton
				.trailingToSuperview(8,toSafeArea: true)
				.leadingToTrailing(of: titleShowLabel, margin: 8)
			
			favoriteButton
				.widthTo(35)
				.heightTo(35)
				.centerVertical(to: showImageLabel)
			
			favoriteButton.setImage(UIImage(systemName: isFavorited ?  "heart.fill" : "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 0, weight: .unspecified, scale: .default)), for: .normal)
			
		}
		
		
		titleShowLabel
			.leadingToTrailing(of: showImageLabel,
							   margin: 8)
			.trailingToSuperview(51)
			.centerVertical(to: showImageLabel)
	}
	
	
	func configView(isSerie: Bool,
					title: String,
					imageUrlStr: String,
					isFavorited: Bool = false,
					showID: Int? = nil,
					showListCellOutput: ShowListCellOutput? = nil) {
		self.outputProtocol = showListCellOutput
		self.isFavorited = isFavorited
		self.showID = showID
		setupUI(isSerie: isSerie, isFavorited: isFavorited)
		
		titleShowLabel.text = title
		showImageLabel.load(url: URL(string: imageUrlStr))
		
	}
	
	@IBAction func favoriteButtonTapped() {
		if let showID = showID {
			outputProtocol?.favoriteClicked(isFavorited: self.isFavorited, and: showID)
		}
	}
}
