//
//  DemoCell2.swift
//  BNomad
//
//  Created by 유재훈 on 2022/10/20.
//

import UIKit

class DemoCell2: UICollectionViewCell {
    static let cellIdentifier = "DemoCell2"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

