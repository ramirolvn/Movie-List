//
//  LoginView.swift
//  movie-list
//
//  Created by Ramiro Lima on 25/01/23.
//

import UIKit
import CommonPackage
import Security
import LocalAuthentication

class LoginView: BaseViewController {
	// MARK: - Properties
	private lazy var logoImageView: UIImageView = {
		let imageView = UIImageView(image: UIImage(systemName: "popcorn.circle.fill"))
		imageView.tintColor = .darkText
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	private lazy var usernameIcon: UIImageView = {
		let imageView = UIImageView(image: UIImage(systemName: "person.circle"))
		imageView.contentMode = .scaleAspectFit
		imageView.tintColor = .darkText
		return imageView
	}()
	
	private lazy var usernameTextField: UITextField = {
		let textField = UITextField()
		textField.attributedPlaceholder = NSAttributedString(
			string: "Username",
			attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkText]
		)
		textField.autocorrectionType = .no
		textField.autocapitalizationType = .none
		textField.returnKeyType = .next
		textField.clearButtonMode = .whileEditing
		textField.backgroundColor = UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.00)
		textField.font = UIFont(name: "AvenirNext-Regular", size: 16)
		textField.layer.cornerRadius = 8
		let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.size.height))
		textField.leftView = paddingView
		textField.leftViewMode = .always
		return textField
	}()
	
	private lazy var passwordIcon: UIImageView = {
		let imageView = UIImageView(image: UIImage(systemName: "key.fill"))
		imageView.contentMode = .scaleAspectFit
		imageView.tintColor = .darkText
		return imageView
	}()
	
	private lazy var passwordTextField: UITextField = {
		let textField = UITextField()
		textField.attributedPlaceholder = NSAttributedString(
			string: "Password",
			attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkText]
		)
		textField.isSecureTextEntry = true
		textField.returnKeyType = .go
		textField.textContentType = .oneTimeCode
		textField.clearButtonMode = .whileEditing
		textField.backgroundColor = UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.00)
		textField.font = UIFont(name: "AvenirNext-Regular", size: 16)
		textField.layer.cornerRadius = 8
		let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.size.height))
		textField.leftView = paddingView
		textField.leftViewMode = .always
		return textField
	}()
	
	private lazy var loginButton: UIButton = {
		let button = UIButton()
		button.layer.cornerRadius = 8
		button.setTitle(viewModel.loginButtonTitle, for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = .darkText
		button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
		button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
		return button
	}()
	
	private lazy var errorLabel: UILabel = {
		let label = UILabel()
		label.textColor = .red
		label.textAlignment = .center
		label.isHidden = true
		return label
	}()
	
	var viewModel: LoginViewModelProtocol = LoginViewModel()
	
	// MARK: - View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		guard LoginService.hasFaceID() else {
			return
		}
		authenticate()
	}
	
	// MARK: - Setup View
	private func setupView() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
		view.addGestureRecognizer(tap)
		bindUI()
		view.addSubviews([logoImageView,
						  usernameIcon,
						  usernameTextField,
						  passwordIcon,
						  passwordTextField,
						  loginButton,
						  errorLabel])
		setupConstraints()
	}
	
	
	// MARK: - Setup Constraints
	private func setupConstraints() {
		logoImageView
			.topToSuperview(32, toSafeArea: true)
			.centerHorizontalToSuperView()
			.heightTo(100)
			.widthTo(100)
		
		usernameTextField
			.topToBottom(of: logoImageView, margin: 16)
			.centerHorizontalToSuperView()
			.widthTo(256)
			.heightTo(44)
		
		usernameIcon
			.widthTo(24)
			.heightTo(24)
			.trailingToLeading(of: usernameTextField, margin: 16)
			.centerVertical(to: usernameTextField)
		
		passwordTextField
			.topToBottom(of: usernameTextField, margin: 16)
			.centerHorizontalToSuperView()
			.widthTo(256)
			.heightTo(44)
		
		passwordIcon
			.widthTo(24)
			.heightTo(24)
			.trailingToLeading(of: passwordTextField, margin: 16)
			.centerVertical(to: passwordTextField)
		
		loginButton
			.topToBottom(of: passwordTextField, margin: 16)
			.centerHorizontalToSuperView()
			.widthTo(150)
			.heightTo(44)
		
		errorLabel
			.topToBottom(of: loginButton, margin: 8)
			.leadingToSuperview(8)
			.trailingToSuperview(8)
		
	}
	
	private func bindUI() {
		viewModel.showErrorAlertPopUp.addObserver({ [weak self] alertError in
			DispatchQueue.main.async {
				guard let self = self,
					  let alertError = alertError else { return }
				let errorAlert = UIAlertController(title: "Error", message: alertError, preferredStyle: UIAlertController.Style.alert)
				
				errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
				}))
				
				self.present(errorAlert, animated: true, completion: nil)
			}
		})
		
		viewModel.logged.addObserver({ [weak self] logged in
			guard let logged = logged, logged else { return}
			self?.authenticate()
		})
		
	}
	
	// MARK: - Actions
	@objc private func didTapLoginButton() {
		viewModel.login(email: usernameTextField.text ?? "", password: passwordTextField.text ?? "")
		
		UIView.animate(withDuration: 0.1, animations: {
			self.loginButton.transform = CGAffineTransform(scaleX: 0, y: 0)
		}) { _ in
			UIView.animate(withDuration: 0.1) {
				self.loginButton.transform = .identity
			}
		}
	}
	
	@objc private func dismissKeyboard() {
		view.endEditing(true)
	}
	
	private func authenticate() {
		let context = LAContext()
		var error: NSError? = nil
		if  context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
			let reason = "Identify yourself!"
			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
								   localizedReason: reason) {
				[weak self] success, authenticationError in
				DispatchQueue.main.async {
					guard success, error == nil else {
						self?.goToListView()
						return
					}
					LoginService.loginByFaceID()
					self?.goToListView()
				}
			}
		} else {
			goToListView()
		}
	}
	
	private func goToListView() {
		let listSeriesView = ShowListView()
		self.navigationController?.viewControllers = [listSeriesView]
	}
}
