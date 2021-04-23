//
//  ExploreViewController.swift
//  Unsplash
//
//  Created by Дарья on 02.04.2021.
//

import UIKit

class ExploreViewController: UIViewController {
    
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var photoResponse: [UnsplashPhoto]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController

        fetchListPhotos()
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func setupCollectionView() {

        let layout = AspectRatioLayout()
        collectionView.collectionViewLayout = layout
        layout.delegate = self
        
        collectionView.backgroundColor = .clear
        collectionView.register(ExploreCollectionViewCell.self, forCellWithReuseIdentifier: ExploreCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
    }
    
    func fetchListPhotos() {
        NetworkManager.shared.getListPhotos { result in
            switch result {
            case .success(let response):
                self.photoResponse = response
            case .failure(let error):
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
    }
    
}

extension ExploreViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoResponse?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCollectionViewCell.identifier, for: indexPath) as? ExploreCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let photo = photoResponse else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: photo[indexPath.item])
        
        return cell
    }
}

extension ExploreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let response = photoResponse else {
            return CGSize(width: 0, height: 0)
        }
        let photo = response[indexPath.item]
        let width = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        let height = CGFloat(photo.height) * width / CGFloat(photo.width)
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
}

extension ExploreViewController: LayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard let photo = photoResponse?[indexPath.item] else { return 240 }
        let aspectRatio: Float = Float(photo.width) / Float(photo.height)
        return (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2 / CGFloat(aspectRatio)
    }
}

extension ExploreViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        NetworkManager.shared.getSearchedPhotos(for: searchText) { result in
            switch result {
            case .success(let response):
                self.photoResponse = response.results
            case .failure(let error):
                print("Error while searching photos occurred: \(error.localizedDescription)")
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchListPhotos()
    }
    
}
