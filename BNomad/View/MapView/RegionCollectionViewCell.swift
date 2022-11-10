//
//  RegionCollectionViewCell.swift
//  BNomad
//
//  Created by Youngwoong Choi on 2022/11/08.
//

import UIKit

class RegionCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RegionCollectionViewCell"

    // MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                regionBtn.textColor = CustomColor.nomadBlue
                regionBtn.layer.borderColor = CustomColor.nomadBlue?.cgColor
            } else {
                regionBtn.textColor = .black
                regionBtn.layer.borderColor = UIColor.black.cgColor

            }
        }
    }
    
    lazy var regionBtn: UILabel = {
        let btn = UILabel()
        btn.text = "지역명"
        btn.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 20
        btn.backgroundColor = .white
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.black.cgColor
        btn.textAlignment = .center
        return btn
    }()
        
//    lazy var cell: UIView = {
//        let view = UIView()
//        view.clipsToBounds = true
//        view.layer.cornerRadius = 20
//        view.backgroundColor = .white
//        view.addSubview(name)
//        name.center(inView: view)
//        return view
//    }()
    
    
    // MARK: - LifeCycle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
    }

    // MARK: - Helpers
    
    func setUpCell() {
        contentView.addSubview(regionBtn)
        regionBtn.anchor(top: self.topAnchor, width: 150, height: 40)
        regionBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
}
