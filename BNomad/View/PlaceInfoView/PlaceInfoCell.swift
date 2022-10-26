//
//  PlaceInfoCell.swift
//  BNomad
//
//  Created by 유재훈 on 2022/10/19.
//

import UIKit
import MapKit

class PlaceInfoCell: UICollectionViewCell {
    static let cellIdentifier = "PlaceInfoCell"
    
    // MARK: - Properties
    
    //current 데이터 없어서 우선 더미로 출력
    var position: CLLocation?

    var place: Place? {
        didSet {
            guard let place = place else { return }
            guard let latitude = position?.coordinate.latitude else { return }
            guard let longitude = position?.coordinate.longitude else { return }
            let distance: Double = CustomCollectionViewCell.calculateDistance(latitude1: latitude, latitude2: place.latitude, longitude1: longitude, longitude2: place.longitude)
            self.distanceLabel.text = distance >= 1.0 ? String(round(distance * 10) / 10.0) + "km" : String(Int(round(distance * 1000))) + "m"
            mappingPlaceData(place)
            FirebaseManager.shared.fetchCheckInHistory(placeUid: place.placeUid) { checkInHistory in
                self.todayCheckInHistory = checkInHistory
            }
        }
    }
    
    var todayCheckInHistory: [CheckIn]? {
        didSet {
            guard let todayCheckInHistory = todayCheckInHistory else {
                print("CustomCollectionViewCell : todayCheckInHistory 가져오기 실패" )
                return
            }
            let history = todayCheckInHistory.filter { $0.checkOutTime == nil }
            self.chekedinViewLabel.text = "\(history.count)명 체크인"
            self.averageTimeLabel.text = CustomCollectionViewCell.calculateAverageTime(todayCheckInHistory: todayCheckInHistory)
        }
    }

    lazy var placeNameLabel: UILabel = {
        let placeNameLabel = UILabel()
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
    
    var detailedCheckinListButton: UIButton = {
        let detailedCheckinListButton = UIButton()
        detailedCheckinListButton.backgroundColor = CustomColor.nomadGray3
        detailedCheckinListButton.layer.cornerRadius = 12
        return detailedCheckinListButton
    }()
    
    lazy var chekedinViewLabel: UILabel = {
        let chekedinViewLabel = UILabel()
        chekedinViewLabel.text = ""
        chekedinViewLabel.textColor = CustomColor.nomadBlack
        chekedinViewLabel.font = .preferredFont(forTextStyle: .body, weight: .regular)
        return chekedinViewLabel
    }()
    
    lazy var averageTimeLabel: UILabel = {
        let averageTimeLabel = UILabel()
        averageTimeLabel.text = ""
        averageTimeLabel.textColor = CustomColor.nomadGray1
        averageTimeLabel.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
        return averageTimeLabel
    }()
    
    private let ProfileCheckedImage: UIImageView = {
        let ProfileCheckedImage = UIImageView()
        ProfileCheckedImage.image = UIImage(named: "ProfileChecked")
        return ProfileCheckedImage
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
        self.addSubview(detailedCheckinListButton)
        self.addSubview(chekedinViewLabel)
        self.addSubview(averageTimeLabel)
        self.addSubview(ProfileCheckedImage)
        self.addSubview(callButton)
        self.addSubview(mapButton)
        self.addSubview(dotImg)
        self.addSubview(dotImg2)
        self.addSubview(operatingStatusLabel)
        self.addSubview(operatingTimeLabel)

        
        setAttributes()
        guard let place = place else { return }
        mappingPlaceData(place)
    }
    
    private func setAttributes() {
        
        placeNameLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 45, paddingLeft: 18)
        distanceLabel.anchor(top: self.topAnchor, left: placeNameLabel.rightAnchor, paddingTop: 56, paddingLeft: 14)
        dateLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 97, paddingLeft: 18)
        detailedCheckinListButton.anchor(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 121, paddingLeft: 17, paddingRight: 17, height: 86)
        chekedinViewLabel.anchor(top: detailedCheckinListButton.topAnchor, left: detailedCheckinListButton.leftAnchor, paddingTop: 22, paddingLeft: 17)
        averageTimeLabel.anchor(top: detailedCheckinListButton.topAnchor, left: detailedCheckinListButton.leftAnchor, paddingTop: 47, paddingLeft: 17)
        ProfileCheckedImage.anchor(top: detailedCheckinListButton.topAnchor, right: detailedCheckinListButton.rightAnchor, paddingTop: 9, paddingRight: 13)
        callButton.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 230, paddingLeft: 20)
        mapButton.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 230, paddingLeft: 74)
        dotImg.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 243, paddingLeft: 64)
        dotImg2.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 243, paddingLeft: 119)
        operatingStatusLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 235, paddingLeft: 138)
        operatingTimeLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 235, paddingLeft: 197)
    }
    
    func mappingPlaceData(_ place: Place) {
        
        placeNameLabel.text = place.name
        
    }

}
