//
//  PlaceInforViewCell.swift
//  BNomad
//
//  Created by yeekim on 2022/10/20.
//

import UIKit

class PlaceInfoViewCell: UICollectionViewCell {
    
    static let identifier = "placeInforViewCell"
    
    // MARK: - Properties
    
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
    
    private let visitorTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "누적 노마더"
        label.font = .preferredFont(forTextStyle: .caption2, weight: .regular)
        label.tintColor = CustomColor.nomadGray1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let visitorsLabel: UILabel = {
        let label = UILabel()
        label.text = "142명"
        label.font = .preferredFont(forTextStyle: .title2, weight: .semibold)
        label.tintColor = CustomColor.nomadGray1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let workHoursTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "누적 근무시간"
        label.font = .preferredFont(forTextStyle: .caption2, weight: .regular)
        label.tintColor = CustomColor.nomadBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let workHoursLabel: UILabel = {
        let label = UILabel()
        label.text = "2173시간"
        label.font = .preferredFont(forTextStyle: .title2, weight: .semibold)
        label.tintColor = CustomColor.nomadGray1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        renderInfo()
        renderAnalysis()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(corder:) has not been implemented")
    }
    
    func renderInfo() {
        // 공간 이름
        self.addSubview(placeNameLable)
        placeNameLable.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 15, paddingLeft: 17)
        // 픽토그램
        self.addSubview(locationIcon)
        locationIcon.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 40, paddingLeft: 18)
        // 소재지
        self.addSubview(locationLabel)
        locationLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 39, paddingLeft: 28)
        // 공지사항
        self.addSubview(placeNoteLabel)
        placeNoteLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 60, paddingLeft: 18)
    }
    
    func renderAnalysis() {
        // 누적 노마더 통계
        self.addSubview(visitorTitleLabel)
        self.addSubview(visitorsLabel)
        visitorTitleLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 115, paddingLeft: 75)
        visitorsLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 135, paddingLeft: 71)
        
        // 누적 근무시간 통계
        self.addSubview(workHoursTitleLabel)
        self.addSubview(workHoursLabel)
        workHoursTitleLabel.anchor(top: self.topAnchor, right: self.rightAnchor, paddingTop: 115, paddingRight: 75)
        workHoursLabel.anchor(top: self.topAnchor, right: self.rightAnchor, paddingTop: 135, paddingRight: 62)
    }
}

