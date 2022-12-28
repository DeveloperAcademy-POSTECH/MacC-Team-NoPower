//
//  ProfileUIImageView.swift
//  BNomad
//
//  Created by 박성수 on 2022/12/25.
//

import UIKit

final class ProfileUIImageView: UIImageView {
    
    init(widthRatio: CGFloat) {
        super.init(frame: .zero)
        
        self.image = UIImage(systemName: "person.crop.circle.fill")
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.layer.cornerRadius = widthRatio / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
