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
    
    private var placeNameLabel = UILabel()
    private var distanceLabel = UILabel()
    private var dateLabel = UILabel()

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
    lazy var callButton = UIButton(configuration: self.configCallButton, primaryAction: nil)
    lazy var mapButton = UIButton(configuration: self.configmapButton, primaryAction: nil)
    
    let checkInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("체크인하기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body, weight: .semibold)
        button.backgroundColor = CustomColor.nomadBlue
        button.layer.cornerRadius = 8
        
        return button
    }()
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        configureUI()
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
        self.addSubview(checkInButton)
        
        setAttributes()
    }
    
    private func setAttributes() {
        placeNameLabel.text = "노마딕 제주"
        placeNameLabel.textColor = CustomColor.nomadBlack
        placeNameLabel.font = .preferredFont(forTextStyle: .title1, weight: .bold)
        placeNameLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 45, paddingLeft: 18)

        distanceLabel.text = "1.5 km"
        distanceLabel.textColor = CustomColor.nomadGray1
        distanceLabel.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
        distanceLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 56, paddingLeft: 167)
        
        dateLabel.text = "2022년 10월 23일"
        dateLabel.textColor = CustomColor.nomadBlack
        dateLabel.font = .preferredFont(forTextStyle: .subheadline, weight: .semibold)
        dateLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 97, paddingLeft: 18)
        
        detailedCheckinViewButton.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 121, paddingLeft: 17)
        

        callButton.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 230, paddingLeft: 20)
        
        mapButton.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 230, paddingLeft: 74)
        
        dotImg.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 243, paddingLeft: 64)
        
        dotImg2.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 243, paddingLeft: 119)
        
        operatingStatusLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 235, paddingLeft: 138)
        
        operatingTimeLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 235, paddingLeft: 197)
        
        checkInButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        checkInButton.widthAnchor.constraint(equalToConstant: 356).isActive = true
        checkInButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        checkInButton.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
        checkInButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true

        }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
