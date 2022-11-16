//
//  VisitCardHeaderCollectionView.swift
//  BNomad
//
//  Created by Beone on 2022/11/15.
//

import UIKit

class VisitCardHeaderCollectionView: UICollectionReusableView {
    static let identifier = "VisitCardHeaderCollectionView"
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let VisitInfoHeader: UILabel = {
        let content = Contents.todayDate()
        let day = String(content["month"] ?? 0) + "월 " + String(content["day"] ?? 0) + "일"
        
        let label = UILabel()
        label.text = day
        label.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        label.textColor = CustomColor.nomadBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUI() {
//        backgroundColor = .systemPink
        addSubview(VisitInfoHeader)
        VisitInfoHeader.anchor(left: self.leftAnchor, paddingLeft: 20)
        VisitInfoHeader.centerY(inView: self)

    }
    
    func configure(with date: String) {
        VisitInfoHeader.text = date
    }
}
