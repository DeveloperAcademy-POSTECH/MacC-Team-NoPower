//
//  DemoCell.swift
//  BNomad
//
//  Created by 유재훈 on 2022/10/19.
//

import UIKit

class DemoCell: UICollectionViewCell {
    static let cellIdentifier = "DemoCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
