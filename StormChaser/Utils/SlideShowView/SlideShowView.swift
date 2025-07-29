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
    
    private var imageObjects: [UIImage] = []
    private var imageURLs: [String] = []
    private var usingURLs: Bool = false
    
    var uiImages: [UIImage]? {
        didSet {
            if let images = uiImages, !images.isEmpty {
                imageObjects = images
                usingURLs = false
                reloadData()
            } else if let urls = urlImages, !urls.isEmpty {
                usingURLs = true
                reloadData()
            } else {
                showNoPhotos()
            }
        }
    }
    
    var urlImages: [String]? {
        didSet {
            if (uiImages == nil || uiImages?.isEmpty == true),
               let urls = urlImages, !urls.isEmpty {
                usingURLs = true
                reloadData()
            } else if (uiImages?.isEmpty ?? true) && (urlImages?.isEmpty ?? true) {
                showNoPhotos()
            }
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = self.bounds
    }
    
    private func setupNoPhotosLabel() {
        noPhotosLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(noPhotosLabel)
        
        NSLayoutConstraint.activate([
            noPhotosLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            noPhotosLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func reloadData() {
        noPhotosLabel.isHidden = true
        collectionView.reloadData()
    }
    
    private func showNoPhotos() {
        imageObjects = []
        imageURLs = []
        usingURLs = false
        collectionView.reloadData()
        noPhotosLabel.isHidden = false
    }
}

extension SlideShowView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usingURLs ? (urlImages?.count ?? 0) : imageObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        if usingURLs {
            if let urls = urlImages, indexPath.item < urls.count,
               let validURL = URL(string: urls[indexPath.item]) {
                cell.setupCellWithImageURL(url: validURL)
            } else {
                showNoPhotos()
            }
        } else {
            if indexPath.item < imageObjects.count {
                cell.setupCellWithImage(image: imageObjects[indexPath.item])
            } else {
                showNoPhotos()
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
