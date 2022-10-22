//
//  ColorViewCell.swift
//  BNomad
//
//  Created by yeekim on 2022/10/21.
//

import UIKit

class ColorViewCell: UICollectionViewCell {
    
    static let identifier = "ColorViewCell"
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = CustomColor.nomadGray2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(corder:) has not been implemented")
    }
}
