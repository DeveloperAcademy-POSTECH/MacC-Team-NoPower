//
//  PlaceInforViewCell.swift
//  BNomad
//
//  Created by yeekim on 2022/10/20.
//

import UIKit

class PlaceInforViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "placeInforViewCell"
    
    private let placeNameLable: UILabel = {
        let label = UILabel()
        label.text = "노마딕 제주"
        label.font = .preferredFont(forTextStyle: .subheadline, weight: .semibold)
        label.textColor = CustomColor.nomadBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "제주시"
        label.font = .preferredFont(forTextStyle: .caption2, weight: .regular)
        label.textColor = CustomColor.nomadGray1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let locationIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "locationIcon")
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()

    private let placeNoteLabel: UILabel = {
        let label = UILabel()
        label.text = "인포데스크는 오전 10시 - 오후 4시 사이에만 운영됩니다. (점심시간포함)"
        label.font = .preferredFont(forTextStyle: .caption2, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
        contentView.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(corder:) has not been implemented")
    }
    
    func render() {
        // 공간 이름
        self.addSubview(placeNameLable)
        placeNameLable.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 10, paddingLeft: 17)
        // 픽토그램
        self.addSubview(locationIcon)
        locationIcon.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 37, paddingLeft: 18)
        // 소재지
        self.addSubview(locationLabel)
        locationLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 36, paddingLeft: 28)
        // 공지사항
        self.addSubview(placeNoteLabel)
        placeNoteLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 60, paddingLeft: 18)
    }
}
