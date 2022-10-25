//
//  SummaryInfoCell.swift
//  BNomad
//
//  Created by 유재훈 on 2022/10/20.
//

import UIKit

class SummaryInfoCell: UICollectionViewCell {
    static let cellIdentifier = "SummaryInfoCell"
    
    // MARK: - Lifecycle
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}