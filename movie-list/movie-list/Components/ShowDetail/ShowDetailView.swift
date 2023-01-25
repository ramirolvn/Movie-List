//
//  ShowDetailViewController.swift
//  movie-list
//
//  Created by Ramiro Lima on 24/01/23.
//

import UIKit
import CommonPackage

class ShowDetailView: BaseViewController, LoadingPresenting {
	
	private lazy var mainScrollView: UIScrollView = {
		let scroll = UIScrollView()
		return scroll
	}()
	
	private lazy var mainView: UIView = {
		let view = UIView()
		return view
	}()
	
	private lazy var mainStackView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		return stack
	}()
	
	private lazy var mainInfoView: UIView = {
		let view = UIView()
		return view
	}()
	
	private lazy var showImage: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	private lazy var scheduleView: UIView = {
		let view = UIView()
		return view
	}()
	
	private lazy var timeLabel: UILabel = {
		let label = UILabel()
		return label
	}()
	
	private lazy var daysTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "Days: "
		return label
	}()
	
	private lazy var genresView: UIView = {
		let view = UIView()
		return view
	}()
	
	private lazy var genresLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14)
		return label
	}()
	
	private lazy var summaryView: UIView = {
		let view = UIView()
		return view
	}()
	
	private lazy var summaryLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		return label
	}()
	
	private lazy var episodesTable: UITableView = {
		let view = UITableView()
		return view
	}()
	
	var viewModel: ShowDetailViewModelProtocol? {
		didSet {
			configView()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		setupView()
	}
	
	func configView(){
		setupBindUI()
		viewModel?.getEpisodes()
		title = viewModel?.show.name
		
		mainInfoView.isHidden = viewModel?.show.image == nil
		showImage.load(url: URL(string: viewModel?.show.image?.medium ?? ""))
		
		scheduleView.isHidden = viewModel?.show.schedule == nil
		timeLabel.text = "Time: " + (viewModel?.show.schedule?.time ?? "")
		daysTitleLabel.text = "Days: " + (viewModel?.show.schedule?.days.joined(separator: ",") ?? "")
		
		genresLabel.text = "Genres: " + "\(viewModel?.show.genres?.joined(separator: ",") ?? "")"
		
		summaryView.isHidden = viewModel?.show.summary?.attributedHtmlString == nil
		summaryLabel.attributedText = viewModel?.show.summary?.attributedHtmlString
		
	}
	
	private func setupView() {
		setupMainView()
		setupScheduleView()
		setupGenreView()
		setupSummaryView()
		setupEpisodesTableView()
		mainStackView
			.addArrangedSubviews([mainInfoView,
								  scheduleView,
								  genresView,
								  summaryView,
								  episodesTable])
		
		
		mainView
			.addSubviews([mainStackView
						 ])
		
		mainScrollView
			.addSubviews([mainView])
		
		view
			.addSubviews([mainScrollView])
		
		mainStackView
			.topToSuperview()
			.leadingToSuperview()
			.bottomToSuperview()
			.trailingToSuperview()
		
		mainView
			.topToSuperview()
			.leadingToLeading(of: view)
			.bottomToSuperview()
			.trailingToTrailing(of: view)
		
		mainScrollView
			.topToSuperview(toSafeArea: true)
			.leadingToSuperview(toSafeArea: true)
			.bottomToSuperview(toSafeArea: true)
			.trailingToSuperview(toSafeArea: true)
		
		
		
		
	}
	
	private func setupMainView() {
		mainInfoView.addSubviews([showImage
								 ])
		
		showImage
			.topToSuperview(8)
			.centerHorizontal(to: mainInfoView)
			.widthTo(150)
			.heightTo(150)
			.bottomToSuperview(8)
	}
	
	private func setupScheduleView() {
		
		scheduleView.addSubviews([timeLabel,
								  daysTitleLabel])
		
		timeLabel
			.topToSuperview(8)
			.leadingToSuperview(16)
			.trailingToSuperview(16)
			.heightTo(25)
		
		daysTitleLabel
			.topToBottom(of: timeLabel, margin: 8)
			.leadingToSuperview(16)
			.trailingToSuperview(16)
			.heightTo(25)
			.bottomToSuperview()
	}
	
	private func setupGenreView() {
		genresView.addSubviews([genresLabel])
		
		genresLabel
			.topToSuperview()
			.leadingToSuperview(16)
			.trailingToSuperview(16)
			.bottomToSuperview()
	}
	
	private func setupSummaryView(){
		summaryView
			.addSubviews([summaryLabel])
		
		summaryLabel
			.leadingToSuperview(16)
			.trailingToSuperview(16)
			.bottomToSuperview(8)
			.topToSuperview(8)
	}
	
	private func setupEpisodesTableView(){
		episodesTable
			.heightTo(view.frame.height/2)
			.leadingToSuperview()
			.trailingToSuperview()
			.topToSuperview()
			.bottomToSuperview()
		episodesTable.dataSource = self
		episodesTable.delegate = self
		episodesTable.register(ShowListCell.self, forCellReuseIdentifier: ShowListCell.className)
	}
	
	private func setupBindUI() {
		viewModel?.episodes.addObserver({[weak self] episodes in
			guard let self = self,
				  let _ = episodes  else { return }
			DispatchQueue.main.async {
				self.episodesTable.reloadData()
			}
		})
		
		viewModel?.isLoadingView.addObserver({[weak self] isLoading in
			guard let self = self,
				  isLoading
			else {
				DispatchQueue.main.async {
					self?.hideLoading()
				}
				return
			}
			DispatchQueue.main.async {
				self.showLoading()
			}
		})
		
		viewModel?.showErrorAlertPopUp.addObserver({ [weak self] alertError in
			DispatchQueue.main.async {
				guard let self = self,
					  let alertError = alertError else { return }
				let errorAlert = UIAlertController(title: "Error", message: alertError, preferredStyle: UIAlertController.Style.alert)
				
				errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
				}))
				
				self.present(errorAlert, animated: true, completion: nil)
			}
		})
	}
	
	
}

//MARK: TABLE VIEW DATASOURCE

extension ShowDetailView: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		viewModel?.seasonsCount ?? 0
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel?.getEpisodesCountBy(season: section) ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		
		guard let episode = viewModel?.getEpisodeBy(index: indexPath.item, and: indexPath.section),
			  let cell = tableView.dequeueReusableCell(withIdentifier: ShowListCell.className, for: indexPath) as? ShowListCell else {
			return cell
		}
		cell.configView(isSerie: false, title: "\(episode.number) - " + (episode.name ), imageUrlStr: episode.image?.medium ?? "")
		return cell
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Season \(viewModel?.seasons[section] ?? 0)"
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
}

//MARK: TABLE VIEW DELEGATE

extension ShowDetailView: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let episodeSelected = viewModel?.getEpisodeBy(index: indexPath.item, and: indexPath.section) else {
			return
		}
		let episodeView = EpisodeDetailView()
		episodeView.viewModel =  EpisodeDetailViewModel(episode: episodeSelected)
		self.navigationController?.pushViewController(episodeView, animated: true)
	}
}

