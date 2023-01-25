import UIKit
import CommonPackage

class EpisodeDetailView: BaseViewController {
	
	// MARK: - UI Elements
	private lazy var episodeImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 10
		imageView.layer.masksToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
	
	private lazy var episodeTitleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 22)
		label.numberOfLines = 0
		label.textColor = .black
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private lazy var episodeSeasonLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 18)
		label.textColor = .darkGray
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private lazy var episodeSummaryLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 18)
		label.textColor = .darkGray
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private lazy var watchButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("See More", for: .normal)
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = .black
		button.layer.cornerRadius = 8
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	var viewModel: EpisodeDetailViewModelProtocol? {
		didSet {
			configView()
		}
	}
	
	// MARK: - View Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Setup UI
		setupUI()
	}
	

	
	// MARK: - UI Setup
	private func setupUI() {
		view.backgroundColor = .white
		
		view.addSubviews([episodeImageView, episodeTitleLabel, episodeSeasonLabel, episodeSummaryLabel, watchButton])
		
		
		episodeImageView
			.topToSuperview(16, toSafeArea: true)
			.leadingToSuperview(16, toSafeArea: true)
			.widthTo(150)
			.heightTo(150)
		
		episodeTitleLabel
			.topToTop(of: episodeImageView)
			.leadingToTrailing(of: episodeImageView, margin: 16)
			.trailingToSuperview(16)
		
		episodeSeasonLabel
			.topToBottom(of: episodeTitleLabel, margin: 8)
			.leadingToLeading(of: episodeTitleLabel)
			.trailingToTrailing(of: episodeTitleLabel)
		
		
		episodeSummaryLabel
			.topToBottom(of: episodeImageView, margin: 16)
			.leadingToSuperview(16)
			.trailingToSuperview(16)
		
		watchButton
			.bottomToSuperview(16)
			.leadingToSuperview(16)
			.trailingToSuperview(16)
			.heightTo(50)
	}
	
	// MARK: - Data Loading
	private func configView() {
		episodeImageView.load(url: URL(string: viewModel?.episode.image?.medium ?? ""))
		episodeTitleLabel.text = "\(viewModel?.episode.number ?? 0) - " + (viewModel?.episode.name ?? "")
		episodeSeasonLabel.text = "Season: \(viewModel?.episode.season ?? 0)"
		episodeSummaryLabel.attributedText = viewModel?.episode.summary.attributedHtmlString
	}
}
