//
//  PlaceInfoCell.swift
//  BNomad
//
//  Created by 유재훈 on 2022/10/19.
//

import UIKit

class PlaceInfoCell: UICollectionViewCell {
    static let cellIdentifier = "DemoCell"
    
    // MARK: - Properties
    
    var configdetailedChekinBtn: UIButton.Configuration = {
        var configdetailedChekinBtn = UIButton.Configuration.filled()
        
        var titlefontstyle = AttributeContainer()
        titlefontstyle.font = UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        titlefontstyle.foregroundColor = CustomColor.nomadBlack
        var subtitlefontstyle = AttributeContainer()
        subtitlefontstyle.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .regular)
        subtitlefontstyle.foregroundColor = CustomColor.nomadGray1
        
        configdetailedChekinBtn.cornerStyle = .fixed
        configdetailedChekinBtn.background.cornerRadius = 12
        configdetailedChekinBtn.image = UIImage(named: "ProfileChecked")
        configdetailedChekinBtn.imagePlacement = .trailing
        configdetailedChekinBtn.imagePadding = 49
        configdetailedChekinBtn.attributedTitle = AttributedString("23명 체크인", attributes: titlefontstyle)
        configdetailedChekinBtn.attributedSubtitle = AttributedString("평균 5시간 근무", attributes: subtitlefontstyle)
        configdetailedChekinBtn.titlePadding = 7
        configdetailedChekinBtn.titleAlignment = .leading
        configdetailedChekinBtn.buttonSize = .large
        configdetailedChekinBtn.baseBackgroundColor = CustomColor.nomadGray3
        configdetailedChekinBtn.baseForegroundColor = .black
        configdetailedChekinBtn.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 17, bottom: 10, trailing: 17)
        return configdetailedChekinBtn
    }()
    
    private var placeNameLabel = UILabel()
    private var distanceLabel = UILabel()
    private var dateLabel = UILabel()

    var configcallBtn: UIButton.Configuration = {
        var configcallBtn = UIButton.Configuration.filled()
        configcallBtn.image = UIImage(named: "Phone")
        configcallBtn.imagePadding = 1
        configcallBtn.buttonSize = .mini
        configcallBtn.baseBackgroundColor = .white
        return configcallBtn
    }()
    
    var configmapBtn: UIButton.Configuration = {
        var configmapBtn = UIButton.Configuration.filled()
        configmapBtn.image = UIImage(named: "Map")
        configmapBtn.imagePadding = 1
        configmapBtn.buttonSize = .mini
        configmapBtn.baseBackgroundColor = .white
        return configmapBtn
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
    
    private var businessStatusLbl: UILabel = {
         var businessStatusLbl = UILabel()
        businessStatusLbl.text = "영업중"
        businessStatusLbl.font = .preferredFont(forTextStyle: .body, weight: .semibold)
        businessStatusLbl.textColor = CustomColor.nomadBlack
         return businessStatusLbl
     }()
    private var timeStatusLbl: UILabel = {
         var timeStatusLbl = UILabel()
        timeStatusLbl.text = "9 : 00 ~ 21 : 00"
        timeStatusLbl.font = .preferredFont(forTextStyle: .body, weight: .regular)
        timeStatusLbl.textColor = CustomColor.nomadBlack
         return timeStatusLbl
     }()
    
    lazy var detailedChekinViewButton = UIButton(configuration: self.configdetailedChekinBtn, primaryAction: nil)
    lazy var callButton = UIButton(configuration: self.configcallBtn, primaryAction: nil)
    lazy var mapButton = UIButton(configuration: self.configmapBtn, primaryAction: nil)
    
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
        self.addSubview(detailedChekinViewButton)
        self.addSubview(callButton)
        self.addSubview(mapButton)
        self.addSubview(dotImg)
        self.addSubview(dotImg2)
        self.addSubview(businessStatusLbl)
        self.addSubview(timeStatusLbl)
        self.addSubview(checkInButton)
        
        setAttributes()
    }
    
    private func setAttributes() {
        placeNameLabel.text = "노마딕 제주"
        placeNameLabel.textColor = CustomColor.nomadBlack
        placeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        placeNameLabel.font = .preferredFont(forTextStyle: .title1, weight: .bold)
        placeNameLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 45, paddingLeft: 18)

        distanceLabel.text = "1.5 km"
        distanceLabel.textColor = CustomColor.nomadGray1
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
        distanceLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 56, paddingLeft: 167)
        
        dateLabel.text = "2022년 10월 23일"
        dateLabel.textColor = CustomColor.nomadBlack
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = .preferredFont(forTextStyle: .subheadline, weight: .semibold)
        dateLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 97, paddingLeft: 18)
        
        detailedChekinViewButton.translatesAutoresizingMaskIntoConstraints = false
        detailedChekinViewButton.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 121, paddingLeft: 17)
        
        callButton.translatesAutoresizingMaskIntoConstraints = false
        callButton.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 230, paddingLeft: 20)
        
        mapButton.translatesAutoresizingMaskIntoConstraints = false
        mapButton.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 230, paddingLeft: 74)
        
        dotImg.translatesAutoresizingMaskIntoConstraints = false
        dotImg.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 243, paddingLeft: 64)
        
        dotImg2.translatesAutoresizingMaskIntoConstraints = false
        dotImg2.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 243, paddingLeft: 119)
        
        businessStatusLbl.translatesAutoresizingMaskIntoConstraints = false
        businessStatusLbl.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 235, paddingLeft: 138)
        
        timeStatusLbl.translatesAutoresizingMaskIntoConstraints = false
        timeStatusLbl.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 235, paddingLeft: 197)
        
        checkInButton.translatesAutoresizingMaskIntoConstraints = false
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
