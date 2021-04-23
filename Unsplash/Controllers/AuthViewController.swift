//
//  AuthViewController.swift
//  Unsplash
//
//  Created by Дарья on 14.04.2021.
//

import UIKit
import SafariServices

class AuthViewController: UIViewController {
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign In with Unsplash", for: .normal)
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    public var completionHandler: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sign In"
        view.backgroundColor = .white
        
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    private func initiateSFSafariVC(with url: URL) {
        let config = SFSafariViewController.Configuration()
        let safariVC = SFSafariViewController(url: url, configuration: config)
        safariVC.delegate = self
        
    present(safariVC, animated: true)
    }
    
    @objc func didTapSignIn() {
        completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success)
            }
        }
        guard let url = AuthManager.shared.signInURL else {
            return
        }
        initiateSFSafariVC(with: url)
    }
    
    private func handleSignIn(_ success: Bool) {
        // Log user in or yell at them for error
        guard success else {
            let alert = UIAlertController(title: "OOPS", message: "Something went wrong when signing in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let mainTabBarVC = TabBarViewController()
        mainTabBarVC.modalPresentationStyle = .fullScreen
        present(mainTabBarVC, animated: true)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            signInButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            signInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            signInButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}

extension AuthViewController: SFSafariViewControllerDelegate {
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        let components = URLComponents.init(url: URL, resolvingAgainstBaseURL: true)
        print(components ?? "no components")
        print(components?.queryItems ?? "no query")
        guard let code = components?.queryItems?.first(where: { $0.name == "code" })?.value else { return }
        controller.dismiss(animated: true) {
            AuthManager.shared.requestToken(for: code) { [weak self] success in
                DispatchQueue.main.async {
                    self?.navigationController?.popToRootViewController(animated: true)
                    self?.completionHandler?(success)
                }
            }
        }
    }
}
