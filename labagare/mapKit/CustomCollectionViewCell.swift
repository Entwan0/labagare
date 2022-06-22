//
//  CustomCollectionViewCell.swift
//  labagare
//
//  Created by volozana on 22/06/2022.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if image != nil {
            imageView.image = image
        }
    }
    
    func configure(image: UIImage) {
        imageView.image = image
    }

}
