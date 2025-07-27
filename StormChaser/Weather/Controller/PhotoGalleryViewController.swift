//
//  PhotoGalleryViewController.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 27/07/25.
//

import UIKit

protocol PhotoGalleryViewControllerDelegate: AnyObject {
    func photoGallery(_ controller: PhotoGalleryViewController, didFinishPicking images: [UIImage])
}

class PhotoGalleryViewController: UIViewController {

    var navigationBarView = UIView()
    var backButton = UIButton(type: .system)
    var titleLabel = UILabel()
    var collectionView: UICollectionView!
    var images: [UIImage] = []
    
    weak var delegate: PhotoGalleryViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupNavigationBar()
        setupCollectionView()
    }

    private func setupNavigationBar() {
        navigationBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBarView)

        NSLayoutConstraint.activate([
            navigationBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBarView.heightAnchor.constraint(equalToConstant: 56)
        ])

        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .label
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        navigationBarView.addSubview(backButton)

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: navigationBarView.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: navigationBarView.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 20)
        ])

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Add Photos"
        titleLabel.font = UIFont(name: "Rubik-SemiBold", size: 17)
        titleLabel.textAlignment = .center
        navigationBarView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: navigationBarView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: navigationBarView.centerYAnchor)
        ])
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.register(AddPhotoCell.self, forCellWithReuseIdentifier: "AddPhotoCell")
    }
    
    @objc func backButtonAction() {
        delegate?.photoGallery(self, didFinishPicking: images)
        self.dismiss(animated: true)
    }
}

extension PhotoGalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1 // includes + cell
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == images.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPhotoCell", for: indexPath) as! AddPhotoCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
            cell.imageView.image = images[indexPath.item]
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == images.count {
            openCamera()
        } else {
            let image = images[indexPath.item]
            presentFullScreenImage(image)
        }
    }

    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }

        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }

    func presentFullScreenImage(_ image: UIImage) {
        let fullVC = FullImageViewController()
        fullVC.image = image
        fullVC.modalPresentationStyle = .overFullScreen
        present(fullVC, animated: true)
    }
}

extension PhotoGalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        if let image = info[.originalImage] as? UIImage {
            images.append(image)
            collectionView.reloadData()
        }
    }
}
