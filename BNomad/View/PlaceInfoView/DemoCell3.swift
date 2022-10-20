//
//  DemoCell3.swift
//  BNomad
//
//  Created by 유재훈 on 2022/10/20.
//

import UIKit

class DemoCell3: UICollectionViewCell {
    static let cellIdentifier = "DemoCell3"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
