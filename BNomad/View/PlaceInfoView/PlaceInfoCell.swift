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
    
    var place: Place? {
        didSet {
            placeNameLabel.text = place?.name
        }
    }
    
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
        // jin 함수 참고 - numberofcheckin,
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
    
    lazy var placeNameLabel: UILabel = {
        let placeNameLabel = UILabel()
        placeNameLabel.text = "애플디벨로퍼디벨로퍼아카"
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
    
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
    
    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.text = formatter.string(from: Date())
        dateLabel.textColor = CustomColor.nomadBlack
        dateLabel.font = .preferredFont(forTextStyle: .subheadline, weight: .semibold)
        return dateLabel
    }()

    // 전화 연결 기능 구현하기
    // 전화 번호 바인딩 (place.contact)
    var configCallButton: UIButton.Configuration = {
        var configCallButton = UIButton.Configuration.filled()
        configCallButton.image = UIImage(systemName: "phone")
        configCallButton.imagePadding = 1
        configCallButton.buttonSize = .mini
        configCallButton.baseBackgroundColor = .white
        configCallButton.baseForegroundColor = .black
        return configCallButton
    }()
    
    // 주소 복사 기능 구현
    // 주소 바인딩 (place.address)
    var configmapButton: UIButton.Configuration = {
        var configmapButton = UIButton.Configuration.filled()
        configmapButton.image = UIImage(systemName: "map")
        configmapButton.imagePadding = 1
        configmapButton.buttonSize = .mini
        configmapButton.baseBackgroundColor = .white
        configmapButton.baseForegroundColor = .black
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
    
    //영업시간 외에 영업끝 함수 만들기
    private var operatingStatusLabel: UILabel = {
         var operatingStatusLabel = UILabel()
        operatingStatusLabel.text = "영업중"
        operatingStatusLabel.font = .preferredFont(forTextStyle: .body, weight: .semibold)
        operatingStatusLabel.textColor = CustomColor.nomadBlack
         return operatingStatusLabel
     }()
    
    // 영업시간 데이터 없음
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
    
    lazy var checkInButton: UIButton = {
        var button = UIButton()
        button.setTitle("체크인 하기", for: .normal)
        button.tintColor = .white
        button.backgroundColor = CustomColor.nomadBlue
        button.layer.cornerRadius = 8
//        button.addTarget(self, action: #selector(setAttributes()), for: .touchUpInside)
//        button.isHidden = self.isCheckedIn ? true : false
        return button
    }()
    
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
        self.addSubview(checkInButton)
        
        setAttributes()
    }
    
    private func setAttributes() {
        
        placeNameLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 45, paddingLeft: 18)
        distanceLabel.anchor(top: self.topAnchor, left: placeNameLabel.rightAnchor, paddingTop: 56, paddingLeft: 14)
        dateLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 97, paddingLeft: 18)
        detailedCheckinViewButton.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 121, paddingLeft: 17)
        callButton.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 230, paddingLeft: 20)
        mapButton.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 230, paddingLeft: 74)
        dotImg.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 243, paddingLeft: 64)
        dotImg2.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 243, paddingLeft: 119)
        operatingStatusLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 235, paddingLeft: 138)
        operatingTimeLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 235, paddingLeft: 197)
        checkInButton.anchor(left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingLeft: 17, paddingBottom: 50, paddingRight: 17, height: 50)

    }

}
