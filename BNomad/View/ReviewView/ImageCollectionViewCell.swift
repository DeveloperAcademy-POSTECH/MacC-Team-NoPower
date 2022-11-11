//
//  ImageCollectionViewCell.swift
//  BNomad
//
//  Created by 박진웅 on 2022/11/11.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    static let identifier = "ImageCollectionViewCell"
    
    // MARK: - Properties
    
    private var photo: UIImageView = {
        let image = UIImage(named: "AppIcon")
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    // MARK: - LifeCycle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(photo)
        photo.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 160, height: 160)
    }
    
}
