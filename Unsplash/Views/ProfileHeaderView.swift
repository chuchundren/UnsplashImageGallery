//
//  ProfileHeaderView.swift
//  Unsplash
//
//  Created by Дарья on 23.04.2021.
//

import UIKit

protocol ProfileHeaderViewDelegate: AnyObject {
    func didChangeSegmentedControlValue(_ header: ProfileHeaderView, for value: Int)
}


class ProfileHeaderView: UICollectionReusableView {
    
    static let identifier = "ProfileHeaderView"
    
    weak var delegate: ProfileHeaderViewDelegate?
    
    private var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var bioLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["User's photos", "Liked photos"])
        control.selectedSegmentTintColor = .black
        control.selectedSegmentIndex = 1
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        return control
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    
    private func setupConstraints() {

        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(usernameLabel)
        addSubview(locationLabel)
        addSubview(bioLabel)
        addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            locationLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            locationLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            bioLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            bioLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            bioLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            segmentedControl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            segmentedControl.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 8)
        ])
    }
    
    public func configure(with viewModel: CurrentUserPrivateProfileViewModel) {
        nameLabel.text = viewModel.name
        usernameLabel.text = viewModel.username
        bioLabel.text = viewModel.bio
        locationLabel.text = viewModel.location
    }
    
    @objc private func segmentedControlValueChanged() {
        delegate?.didChangeSegmentedControlValue(self, for: segmentedControl.selectedSegmentIndex)
    }
}
