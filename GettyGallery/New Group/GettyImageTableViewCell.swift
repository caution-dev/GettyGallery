//
//  GettyImageTableViewCell.swift
//  GettyGallery
//
//  Created by juhee on 05/04/2019.
//  Copyright © 2019 caution-dev. All rights reserved.
//

import UIKit

class GettyImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var gettyImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    private var imageUrl: URL?
    
    func bind(source: GettyImage) {
        titleLabel.text = source.name
        imageUrl = source.src
        if let imageUrl = source.src {
            ImageManager.shared.fetchImage(url: imageUrl) { [weak self] image in
                if self?.imageUrl == source.src {
                    self?.gettyImageView.image = image
                }
            }
        }
    }
    
    override func awakeFromNib() {
        outerView.clipsToBounds = false
        outerView.layer.cornerRadius = 10
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 0.5
        outerView.layer.shadowOffset = CGSize(width: 10, height: 10)
        outerView.layer.shadowRadius = 10
    }
}
