//
//  FeedViewController.swift
//  Unsplash
//
//  Created by Дарья on 02.04.2021.
//

import UIKit

class FeedViewController: UIViewController {
    
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: FeedViewController.flowLayout())
    
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
        
        setupCollectionView()
        fetchListPhotos()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
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
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        
        let layout = AspectRatioLayout()
        layout.numberOfColumns = 1
        collectionView.collectionViewLayout = layout
        layout.delegate = self
        
        collectionView.backgroundColor = .clear
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private static func flowLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }
    
}

extension FeedViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoResponse?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.identifier, for: indexPath) as? FeedCollectionViewCell else {
            fatalError()
        }
        guard let photo = photoResponse else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: photo[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = SinglePhotoViewController()
        vc.photoID = photoResponse?[indexPath.item].id
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width - 8, height: view.bounds.height / 2)
    }
}

extension FeedViewController: LayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard let photo = photoResponse?[indexPath.item] else { return 240 }
        let aspectRatio: Float = Float(photo.width) / Float(photo.height)
        return (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / CGFloat(aspectRatio)
    }
}
