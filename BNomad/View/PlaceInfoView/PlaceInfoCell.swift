//
//  PlaceInfoCell.swift
//  BNomad
//
//  Created by 유재훈 on 2022/10/19.
//

import UIKit

class PlaceInfoCell: UICollectionViewCell {
    static let cellIdentifier = "PlaceInfoCell"
    
    // MARK: - Properties
    
    var configDetailedCheckinButton: UIButton.Configuration = {
        var configDetailedCheckinButton = UIButton.Configuration.filled()
        
        var titleFontstyle = AttributeContainer()
        titleFontstyle.font = UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        titleFontstyle.foregroundColor = CustomColor.nomadBlack
        var subTitleFontstyle = AttributeContainer()
        subTitleFontstyle.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .regular)
        subTitleFontstyle.foregroundColor = CustomColor.nomadGray1
        
        configDetailedCheckinButton.cornerStyle = .fixed
        configDetailedCheckinButton.background.cornerRadius = 12
        configDetailedCheckinButton.image = UIImage(named: "ProfileChecked")
        configDetailedCheckinButton.imagePlacement = .trailing
        configDetailedCheckinButton.imagePadding = 49
        configDetailedCheckinButton.attributedTitle = AttributedString("23명 체크인", attributes: titleFontstyle)
        configDetailedCheckinButton.attributedSubtitle = AttributedString("평균 5시간 근무", attributes: subTitleFontstyle)
        configDetailedCheckinButton.titlePadding = 7
        configDetailedCheckinButton.titleAlignment = .leading
        configDetailedCheckinButton.buttonSize = .large
        configDetailedCheckinButton.baseBackgroundColor = CustomColor.nomadGray3
        configDetailedCheckinButton.baseForegroundColor = .black
        configDetailedCheckinButton.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 17, bottom: 10, trailing: 17)
        return configDetailedCheckinButton
    }()
    
    private var placeNameLabel: UILabel = {
        let placeNameLabel = UILabel()
        placeNameLabel.text = "노마딕 제주"
        placeNameLabel.textColor = CustomColor.nomadBlack
        placeNameLabel.font = .preferredFont(forTextStyle: .title1, weight: .bold)
        return placeNameLabel
    }()
    
    private var distanceLabel: UILabel = {
        let distanceLabel = UILabel()
        distanceLabel.text = "1.5 km"
        distanceLabel.textColor = CustomColor.nomadGray1
        distanceLabel.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
        return distanceLabel
    }()
    private var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.text = "2022년 10월 23일"
        dateLabel.textColor = CustomColor.nomadBlack
        dateLabel.font = .preferredFont(forTextStyle: .subheadline, weight: .semibold)
        return dateLabel
    }()

    var configCallButton: UIButton.Configuration = {
        var configCallButton = UIButton.Configuration.filled()
        configCallButton.image = UIImage(named: "Phone")
        configCallButton.imagePadding = 1
        configCallButton.buttonSize = .mini
        configCallButton.baseBackgroundColor = .white
        return configCallButton
    }()
    
    var configmapButton: UIButton.Configuration = {
        var configmapButton = UIButton.Configuration.filled()
        configmapButton.image = UIImage(named: "Map")
        configmapButton.imagePadding = 1
        configmapButton.buttonSize = .mini
        configmapButton.baseBackgroundColor = .white
        return configmapButton
    }()
    private let dotImg : UIImageView = {
        let dotImg = UIImageView()
        dotImg.image = UIImage(named: "Dot")
        return dotImg
    }()
    private let dotImg2 : UIImageView = {
        let dotImg2 = UIImageView()
        dotImg2.image = UIImage(named: "Dot")
        return dotImg2
    }()
    
    private var operatingStatusLabel: UILabel = {
         var operatingStatusLabel = UILabel()
        operatingStatusLabel.text = "영업중"
        operatingStatusLabel.font = .preferredFont(forTextStyle: .body, weight: .semibold)
        operatingStatusLabel.textColor = CustomColor.nomadBlack
         return operatingStatusLabel
     }()
    private var operatingTimeLabel: UILabel = {
         var operatingTimeLabel = UILabel()
        operatingTimeLabel.text = "9 : 00 ~ 21 : 00"
        operatingTimeLabel.font = .preferredFont(forTextStyle: .body, weight: .regular)
        operatingTimeLabel.textColor = CustomColor.nomadBlack
         return operatingTimeLabel
     }()
    
    lazy var detailedCheckinViewButton = UIButton(configuration: self.configDetailedCheckinButton, primaryAction: nil)
    lazy var callButton = UIButton(configuration: self.configCallButton, primaryAction: UIAction(handler: { action in
        print("전화로 이어주게나,,")
    }))
    lazy var mapButton = UIButton(configuration: self.configmapButton, primaryAction: nil)
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        self.addSubview(placeNameLabel)
        self.addSubview(distanceLabel)
        self.addSubview(dateLabel)
        self.addSubview(detailedCheckinViewButton)
        self.addSubview(callButton)
        self.addSubview(mapButton)
        self.addSubview(dotImg)
        self.addSubview(dotImg2)
        self.addSubview(operatingStatusLabel)
        self.addSubview(operatingTimeLabel)
        
        setAttributes()
    }
    
    private func setAttributes() {
        
        placeNameLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 45, paddingLeft: 18)
        distanceLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 56, paddingLeft: 167)
        dateLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 97, paddingLeft: 18)
        detailedCheckinViewButton.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 121, paddingLeft: 17)
        callButton.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 230, paddingLeft: 20)
        mapButton.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 230, paddingLeft: 74)
        dotImg.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 243, paddingLeft: 64)
        dotImg2.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 243, paddingLeft: 119)
        operatingStatusLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 235, paddingLeft: 138)
        operatingTimeLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 235, paddingLeft: 197)

    }

}
