//
//  ProfileViewController.swift
//  Unsplash
//
//  Created by Дарья on 02.04.2021.
//

import UIKit
import WebKit

class ProfileViewController: UIViewController {
    
    private var viewModel: CurrentUserPrivateProfileViewModel? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private var photos: [UnsplashPhoto] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionViewBackground()
            }
        }
    }
    
    private var user: CurrentUserPrivateProfile?
    
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    lazy var emptyStateMessageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = "No photos yet"
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 20)
        messageLabel.sizeToFit()
        return messageLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        setupCollectionView()
        getUser()
        collectionViewBackground()
    }
    
    fileprivate func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: 200)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        collectionView.register(ProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeaderView.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
    }
    
    private func collectionViewBackground() {
        if photos.isEmpty {
            let mainView = UIView()
            mainView.addSubview(emptyStateMessageLabel)
            NSLayoutConstraint.activate([
                emptyStateMessageLabel.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
                emptyStateMessageLabel.centerXAnchor.constraint(equalTo: mainView.centerXAnchor)
            ])
            collectionView.backgroundView = mainView
        } else {
            collectionView.backgroundView = nil
        }
    }
    
    private func getUser() {
        NetworkManager.shared.loadSingleObject(with: Route.currentUser) { (result: Result<CurrentUserPrivateProfile, Error>) in
            switch result {
            case .success(let user):
                self.viewModel = CurrentUserPrivateProfileViewModel(currentUser: user)
                self.user = user
                    NetworkManager.shared.loadAnArray(with: Route.usersPhotos(username: user.username)) { (photoResult: Result<[UnsplashPhoto], Error>) in
                        switch photoResult {
                        case .success(let response):
                            self.photos = response
                        case .failure(let error):
                            print(error)
                        }
                    }
            case .failure(let error):
                print("Error occured: \(error.localizedDescription), \(error)")
            }
        }
    }
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProfileCollectionViewCell.identifier,
                for: indexPath) as? ProfileCollectionViewCell else {
            fatalError("Couldn't dequeue a cell")
        }
        let photo = photos[indexPath.item]
        cell.configure(with: photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: ProfileHeaderView.identifier, for: indexPath) as? ProfileHeaderView else {
            fatalError("Couldn't dequeue a header view")
        }
        if let viewModel = viewModel {
            header.configure(with: viewModel)
        }
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = SinglePhotoViewController()
        vc.photoID = photos[indexPath.item].id
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.bounds.width) / 3
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension ProfileViewController: ProfileHeaderViewDelegate {
    func didChangeSegmentedControlValue(_ header: ProfileHeaderView, for value: Int) {
        guard let user = user else {
            return
        }
        if value == 0 {
            NetworkManager.shared.loadAnArray(with: Route.usersPhotos(username: user.username)) { (photoResult: Result<[UnsplashPhoto], Error>) in
                switch photoResult {
                case .success(let response):
                    self.photos = response
                case .failure(let error):
                    print(error)
                }
            }
        } else if value == 1 {
            NetworkManager.shared.loadAnArray(with: Route.usersLikedPhotos(username: user.username)) { (photoResult: Result<[UnsplashPhoto], Error>) in
                switch photoResult {
                case .success(let response):
                    self.photos = response
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
