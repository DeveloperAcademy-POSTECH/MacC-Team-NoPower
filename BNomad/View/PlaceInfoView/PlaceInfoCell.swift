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
    
    private var placeNameLabel: UILabel = {
        let placeNameLabel = UILabel()
        placeNameLabel.text = "쌍사벅스"
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
    
    private let detailedCheckinViewLabel: UILabel = {
        let detailedLabel = UILabel()
        detailedLabel.backgroundColor = .white
        detailedLabel.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        detailedLabel.layer.cornerRadius = 12
        detailedLabel.layer.borderWidth = 1
        detailedLabel.layer.borderColor = UIColor(red: 0.898, green: 0.898, blue: 0.918, alpha: 1).cgColor

        return detailedLabel
    }()
    

    
    var configCallButton: UIButton.Configuration = {
        var configCallButton = UIButton.Configuration.filled()
        configCallButton.image = UIImage(systemName: "phone")
        configCallButton.imagePadding = 1
        configCallButton.buttonSize = .mini
        configCallButton.baseBackgroundColor = .white
        configCallButton.baseForegroundColor = .black
        return configCallButton
    }()
    
    private let dotImg : UIImageView = {
        let dotImg = UIImageView()
        dotImg.image = UIImage(named: "Dot")
        return dotImg
    }()
    
    var configmapButton: UIButton.Configuration = {
        var configmapButton = UIButton.Configuration.filled()
        configmapButton.image = UIImage(systemName: "map")
        configmapButton.imagePadding = 1
        configmapButton.buttonSize = .mini
        configmapButton.baseBackgroundColor = .white
        configmapButton.baseForegroundColor = .black
        return configmapButton
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
    
    private var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.text = "2022년 10월 23일"
        dateLabel.textColor = CustomColor.nomadBlack
        dateLabel.font = .preferredFont(forTextStyle: .subheadline, weight: .semibold)
        return dateLabel
    }()
    
    private var checkInCountLable: UILabel = {
        let countLabel = UILabel()
        countLabel.text = "3명 체크인"
        countLabel.textColor = CustomColor.nomadBlack
        countLabel.font = .preferredFont(forTextStyle: .body, weight: .regular)
        return countLabel
    }()
    
    
    lazy var checkInViewAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체보기", for: .normal)
        button.setTitleColor(CustomColor.nomadGray1, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
        button.addTarget(self, action: #selector(checkInViewAllButtonTaped), for: .touchUpInside)
        return button
    }()
    
    private let personImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.circle.fill")
        image.tintColor = CustomColor.nomadGray2
        image.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        
        return image
    }()
    
    private let personImage2 : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.circle.fill")
        image.tintColor = CustomColor.nomadGray2
        image.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        return image
    }()
    
    private let personImage3 : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.circle.fill")
        image.tintColor = CustomColor.nomadGray2
        image.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        return image
    }()
    
    lazy var callButton = UIButton(configuration: self.configCallButton, primaryAction: UIAction(handler: { action in
        print("전화로 이어주게나,,")
    }))
    lazy var mapButton = UIButton(configuration: self.configmapButton, primaryAction: UIAction(handler: { action in print("지도로 이어주게나,,")
    }))
    @objc func checkInViewAllButtonTaped(_button: UIButton){
        print("전체로 보아라,,")
    }

    
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
        self.addSubview(detailedCheckinViewLabel)
        self.addSubview(placeNameLabel)
        self.addSubview(distanceLabel)
        self.addSubview(dateLabel)
        self.addSubview(callButton)
        self.addSubview(mapButton)
        self.addSubview(dotImg)
        self.addSubview(dotImg2)
        self.addSubview(operatingStatusLabel)
        self.addSubview(operatingTimeLabel)
        self.addSubview(checkInCountLable)
        self.addSubview(checkInViewAllButton)
        self.addSubview(personImage)
        self.addSubview(personImage2)
        self.addSubview(personImage3)
        
        
        setAttributes()
    }
    
    private func setAttributes() {
        
        placeNameLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 45, paddingLeft: 25)
        distanceLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 56, paddingLeft: 135)
     
        detailedCheckinViewLabel.anchor(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 125, paddingLeft: 20, paddingRight: 20, height: 122)
        callButton.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 91, paddingLeft: 13)
        mapButton.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 91, paddingLeft: 69)
        dotImg.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 104, paddingLeft: 60)
        dotImg2.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 104, paddingLeft: 118)
        operatingStatusLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 96, paddingLeft: 135)
        operatingTimeLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 96, paddingLeft: 194)
        dateLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 141, paddingLeft: 38)
        checkInCountLable.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 139, paddingLeft: 168)
        checkInViewAllButton.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 135, paddingLeft: 298)
        personImage.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 174, paddingLeft: 38)
        personImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        personImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        personImage2.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 174, paddingLeft: 75)
        personImage2.widthAnchor.constraint(equalToConstant: 60).isActive = true
        personImage2.heightAnchor.constraint(equalToConstant: 60).isActive = true
        personImage3.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 174, paddingLeft: 115)
        personImage3.widthAnchor.constraint(equalToConstant: 60).isActive = true
        personImage3.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }

}
