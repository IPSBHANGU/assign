//
//  ImageViewController.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 29/07/25.
//

import UIKit
import Kingfisher

class ImageViewController: UIViewController {

    // MARK: UIElements
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var startFrame: CGRect?
    var useURL: Bool = false
    var image: UIImage?
    var imageURL: URL?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        backgroundView.alpha = 0
        
        UIView.animate(withDuration: 0.30) {
            self.imageView.transform = .identity
            
            UIView.animate(withDuration: 0.30) {
                self.backgroundView.alpha = 1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setData()
        setupUI()
    }
    
    func setData() {
        if useURL {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: imageURL)
        } else {
            imageView.image = image
        }
    }
    
    func setupUI() {
        guard let startFrame = startFrame else {return}
        imageView.transform = CGAffineTransform(from: imageView.frame, to: startFrame)
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
    }

    @IBAction func backButtonAction(_ sender: Any) {
        guard let startFrame = startFrame else {return}
        UIView.animate(withDuration: 0.30) {
            self.imageView.transform = CGAffineTransform(from: self.imageView.frame, to: startFrame)
            self.backgroundView.alpha = 0
            self.backButton.alpha = 0
            self.imageView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
}
