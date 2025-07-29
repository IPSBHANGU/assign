//
//  SlideShowView.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 29/07/25.
//

import UIKit

class SlideShowView: UIView {
    
    var collectionView: UICollectionView!
    private var timer: Timer?
    private var currentIndex: Int = 0
    
    private let noPhotosLabel: UILabel = {
        let label = UILabel()
        label.text = "No Photos"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    var images: [UIImage] = [] {
        didSet {
            collectionView.reloadData()
            noPhotosLabel.isHidden = !images.isEmpty
        }
    }
    
    var pageChanged: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        setupNoPhotosLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
        setupNoPhotosLabel()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        
        addSubview(collectionView)
    }
    
    private func setupNoPhotosLabel() {
        noPhotosLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(noPhotosLabel)
        
        NSLayoutConstraint.activate([
            noPhotosLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            noPhotosLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}

extension SlideShowView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.imageView.image = images[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

