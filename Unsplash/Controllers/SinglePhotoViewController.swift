//
//  SinglePhotoViewController.swift
//  Unsplash
//
//  Created by Дарья on 16.04.2021.
//

import UIKit

class SinglePhotoViewController: UIViewController {
    
    var photoAspectRatio: CGFloat = 1
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private var userProfilePhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 28
        imageView.clipsToBounds = true
        return imageView
    }()
    
     private var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.sizeToFit()
        return imageView
    }()
    
    private var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private var creationDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    
    private var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 28))
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .lightGray
        button.backgroundColor = .white
        button.layer.cornerRadius = 26
        button.layer.opacity = 0.5
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var likesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    
    public var photoID: String? {
        didSet {
            fetchSinglePhoto()
        }
    }
    
    private var photoViewModel: SinglePhotoViewModel? {
        didSet {
            DispatchQueue.main.async {
                self.setPhoto()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray
    
    }
   
    private func setPhoto() {
        guard let viewModel = photoViewModel else {
            return
        }
        photoImageView.load(url: viewModel.photoURL)
        userProfilePhotoImageView.load(url: viewModel.profilePhotoURL)
        usernameLabel.text = viewModel.username
        creationDateLabel.text = viewModel.creationDate
        locationLabel.text = viewModel.location
        descriptionLabel.text = viewModel.photoDescription
        
        if viewModel.likedByUser == true {
            self.likeButton.tintColor = .systemPink
        } else {
            self.likeButton.tintColor = .lightGray
        }
        
        setupViews(aspectRatio: CGFloat(viewModel.aspectRatio))
    }
    
    private func setupViews(aspectRatio: CGFloat) {
        let likeButtonPosition = view.bounds.width / aspectRatio + 20
        
        view.addSubview(scrollView)
        view.addSubview(likeButton)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(userProfilePhotoImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(creationDateLabel)
        contentView.addSubview(photoImageView)
        contentView.addSubview(locationLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(likesLabel)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.heightAnchor.constraint(equalTo: view.heightAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            photoImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/aspectRatio),
            
            userProfilePhotoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            userProfilePhotoImageView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 8),
            userProfilePhotoImageView.widthAnchor.constraint(equalToConstant: 56),
            userProfilePhotoImageView.heightAnchor.constraint(equalToConstant: 56),

            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            usernameLabel.leadingAnchor.constraint(equalTo: userProfilePhotoImageView.trailingAnchor, constant: 8),
            usernameLabel.topAnchor.constraint(equalTo: userProfilePhotoImageView.topAnchor),
            
            locationLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: creationDateLabel.leadingAnchor),
            locationLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            
            creationDateLabel.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor),
            creationDateLabel.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: userProfilePhotoImageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: userProfilePhotoImageView.bottomAnchor, constant: 8),
            
            likeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            likeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: likeButtonPosition),
            likeButton.widthAnchor.constraint(equalToConstant: 52),
            likeButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func fetchSinglePhoto() {
        guard let id = photoID else { return }
        NetworkManager.shared.loadSingleObject(with: Route.photo(id: id)) { (result: Result<UnsplashPhoto, Error>) in
            switch result {
            case .success(let photo):
                let viewModel = SinglePhotoViewModel(with: photo)
                self.photoViewModel = viewModel
            case .failure(let error):
                print(error.localizedDescription, error)
            }
        }
        
        
    }
    
    @objc func likeButtonTapped() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
                self.likeButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.likeButton.layer.opacity = 1
            }, completion: { _ in
                UIView.animate(withDuration:0.1) {
                    self.likeButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.likeButton.layer.opacity = 0.5
                }
            })
        }
        guard let id = photoID else { return }
        guard let viewModel = photoViewModel else { return }
        if viewModel.likedByUser == false {
            NetworkManager.shared.loadSingleObject(with: Route.likePhoto(id: id)) { (result: Result<LikeResponse, Error>) in
                switch result {
                case .success(let response):
                    guard let photo = response.photo else {
                        return
                    }
                    let viewModel = SinglePhotoViewModel(with: photo)
                    self.photoViewModel = viewModel
                case .failure(let error):
                    print(error.localizedDescription, error)
                }
            }
        } else {
            NetworkManager.shared.loadSingleObject(with: Route.unlikePhoto(id: id)) { (result: Result<LikeResponse, Error>) in
                switch result {
                case .success(let response):
                    guard let photo = response.photo else {
                        return
                    }
                    let viewModel = SinglePhotoViewModel(with: photo)
                    self.photoViewModel = viewModel
                case .failure(let error):
                    print(error.localizedDescription, error)
                }
            }
        }
    }
    
}

