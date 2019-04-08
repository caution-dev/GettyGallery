//
//  DetailViewController.swift
//  GettyGallery
//
//  Created by juhee on 08/04/2019.
//  Copyright © 2019 caution-dev. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    private var imageUrl: URL!
    private var gettyImages: [GettyImage] = []
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.maximumZoomScale = 5.0
        scrollView.minimumZoomScale = 1.0
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubViews()

        ImageManager.shared.fetchImage(url: imageUrl) { [weak self] (image) in
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
            }
        }
    }
    
    func bind(imageUrl: URL) {
        self.imageUrl = imageUrl
    }
    
    private func setUpSubViews() {
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.addSubview(imageView)
        view.backgroundColor = .black
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
            ])
    }

}

extension DetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
