//
//  PlaceInfoCell.swift
//  BNomad
//
//  Created by 유재훈 on 2022/10/19.
//

import UIKit
import MapKit
import Combine

protocol CheckInOut {
    func checkInTapped()
    func checkOutTapped()
}

class PlaceInfoCell: UICollectionViewCell {
    static let cellIdentifier = "PlaceInfoCell"
    
    // MARK: - Properties
    var delegate: CheckInOut?
    var viewModel = CombineViewModel.shared
    
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
            self.userCheck()
        }
    }
    
    var todayCheckInHistory: [CheckIn]? {
        didSet {
            guard let todayCheckInHistory = todayCheckInHistory else {
                print("CustomCollectionViewCell : todayCheckInHistory 가져오기 실패" )
                return
            }
            let history = todayCheckInHistory.filter { $0.checkOutTime == nil }
            self.chekedinViewLabel.text = "\(history.count)명의 노마더"
            let fullText = chekedinViewLabel.text ?? ""
            let attribtuedString = NSMutableAttributedString(string: fullText)
            let range = (fullText as NSString).range(of: "\(history.count)명")
            attribtuedString.addAttribute(.foregroundColor, value: CustomColor.nomadBlue as Any, range: range)
            chekedinViewLabel.attributedText = attribtuedString
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
        distanceLabel.textColor = CustomColor.nomadGray1
        distanceLabel.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
        return distanceLabel
    }()
    
    lazy var chekedinViewLabel: UILabel = {
        let chekedinViewLabel = UILabel()
        chekedinViewLabel.textColor = CustomColor.nomadBlack
        chekedinViewLabel.font = .preferredFont(forTextStyle: .body, weight: .regular)
        return chekedinViewLabel
    }()
    
    let verticalDivider: UILabel = {
        let verticalDivider = UILabel()
        verticalDivider.backgroundColor = CustomColor.nomadBlack
        return verticalDivider
    }()
    
    lazy var questLabel: UILabel = {
        let questLabel = UILabel()
        questLabel.text = "5개의 밋업"
        questLabel.textColor = CustomColor.nomadBlack
        questLabel.font = .preferredFont(forTextStyle: .body, weight: .regular)
        let fullText = questLabel.text ?? ""
        let attribtuedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "5개")
        attribtuedString.addAttribute(.foregroundColor, value: CustomColor.nomadBlue as Any, range: range)
        questLabel.attributedText = attribtuedString
        
        return questLabel
    }()
    
    lazy var checkInButton: UIButton = {
        var button = UIButton()
        button.setTitle("체크인 하기", for: .normal)
        button.tintColor = .white
        button.backgroundColor = CustomColor.nomadBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(checkInTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var checkOutButton: UIButton = {
        var button = UIButton()
        button.setTitle("체크아웃 하기", for: .normal)
        button.tintColor = .white
        button.backgroundColor = CustomColor.nomadBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(checkOutTapped), for: .touchUpInside)
        return button
    }()
    
    private let alreadyCheckIn: UIView = {
        let alreadyView = UIView()
        let label = UILabel()
        label.text = "다른 곳에 체크인 되어 있습니다."
        label.textColor = .white
        alreadyView.addSubview(label)
        label.centerX(inView: alreadyView)
        label.centerY(inView: alreadyView)
        alreadyView.backgroundColor = CustomColor.nomadGray1
        alreadyView.layer.cornerRadius = 8
        return alreadyView
    }()
    
    let horizontalDivider: UILabel = {
        let horizontalDivider = UILabel()
        horizontalDivider.backgroundColor = CustomColor.nomadGray2
        return horizontalDivider
    }()
    // 전화 연결 기능 구현하기
    // 전화 번호 바인딩 (place.contact)
    let callButton: UIButton = {
        let callButton = UIButton()
        callButton.setImage(UIImage(systemName: "phone"), for: .normal)
        callButton.setPreferredSymbolConfiguration(.init(pointSize: 19, weight: .regular, scale: .default), forImageIn: .normal)
        callButton.tintColor = CustomColor.nomadBlack
        return callButton
    }()
    let phoneNumberLable: UILabel = {
        let phoneNumberLable = UILabel()
        phoneNumberLable.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .regular)
        phoneNumberLable.textColor = CustomColor.nomadBlack
        return phoneNumberLable
    }()
        
    let horizontalDivider1: UILabel = {
        let horizontalDivider1 = UILabel()
        horizontalDivider1.backgroundColor = CustomColor.nomadGray2
        return horizontalDivider1
    }()
    // 주소 복사 기능 구현
    // 주소 바인딩 (place.address)
    let mapButton: UIButton = {
        let mapButton = UIButton()
        mapButton.setImage(UIImage(systemName: "map"), for: .normal)
        mapButton.setPreferredSymbolConfiguration(.init(pointSize: 19, weight: .regular, scale: .default), forImageIn: .normal)
        mapButton.tintColor = CustomColor.nomadBlack
        return mapButton
    }()
    let addressLabel: UILabel = {
        let addressLable = UILabel()
        addressLable.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .regular)
        addressLable.textColor = CustomColor.nomadBlack
        return addressLable
    }()
    
//    private var chevronDirection: String = "chevron.down"
    
//    private lazy var openOperatingTimeButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(systemName: chevronDirection)?.withTintColor(CustomColor.nomadGray1 ?? .blue, renderingMode: .alwaysOriginal), for: .normal)
//        button.setTitleColor(CustomColor.nomadSkyblue, for: .normal)
//        button.addTarget(self, action: #selector(openOrClose), for: .touchUpInside)
//        return button
//    }()
    
    let horizontalDivider2: UILabel = {
        let horizontalDivider2 = UILabel()
        horizontalDivider2.backgroundColor = CustomColor.nomadGray2
        return horizontalDivider2
    }()
    let clockButton: UIButton = {
        let clockButton = UIButton()
        clockButton.setImage(UIImage(systemName: "clock"), for: .normal)
        clockButton.setPreferredSymbolConfiguration(.init(pointSize: 19, weight: .regular, scale: .default), forImageIn: .normal)
        clockButton.tintColor = CustomColor.nomadBlack
        return clockButton
    }()
    let horizontalDivider3: UILabel = {
        let horizontalDivider3 = UILabel()
        horizontalDivider3.backgroundColor = CustomColor.nomadGray2
        return horizontalDivider3
    }()
    //영업시간 외에 영업끝 함수 만들기
//    private var operatingStatusLabel: UILabel = {
//         var operatingStatusLabel = UILabel()
//        operatingStatusLabel.text = "영업중"
//        operatingStatusLabel.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
//        operatingStatusLabel.textColor = CustomColor.nomadBlack
//         return operatingStatusLabel
//     }()
    
    // 영업시간 데이터 없음
    private var operatingTimeLabel: UILabel = {
         var operatingTimeLabel = UILabel()
        operatingTimeLabel.numberOfLines = 3
        operatingTimeLabel.lineBreakMode = .byWordWrapping
        operatingTimeLabel.text = "주중 10:00 - 22:00\n주말 9:00 - 20:00\n한줄 여유"
        operatingTimeLabel.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
        operatingTimeLabel.textColor = CustomColor.nomadBlack

         return operatingTimeLabel
     }()
    
    var store = Set<AnyCancellable>()

    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        userCheck()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func userCheck() {
        viewModel.$user
            .sink { user in
                if user == nil {
                    self.checkInButton.isHidden = false
                    self.checkOutButton.isHidden = true
                    self.alreadyCheckIn.isHidden = true
                } else {
                    guard let user = user else { return }
                    if user.isChecked && self.place?.placeUid == user.currentCheckIn?.placeUid {
                        self.checkInButton.isHidden = true
                        self.checkOutButton.isHidden = false
                        self.alreadyCheckIn.isHidden = true
                    } else if user.isChecked && self.place?.placeUid != user.currentCheckIn?.placeUid {
                        self.checkInButton.isHidden = true
                        self.checkOutButton.isHidden = true
                        self.alreadyCheckIn.isHidden = false
                    } else {
                        self.checkInButton.isHidden = false
                        self.checkOutButton.isHidden = true
                        self.alreadyCheckIn.isHidden = true
                    }
                }
            }
            .store(in: &store)
    }
    
    // MARK: - Actions
    
    @objc func checkInTapped() {
        delegate?.checkInTapped()
    }
    
    @objc func checkOutTapped() {
        delegate?.checkOutTapped()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        self.addSubview(placeNameLabel)
        self.addSubview(distanceLabel)
        self.addSubview(chekedinViewLabel)
        self.addSubview(verticalDivider)
        self.addSubview(questLabel)
        self.addSubview(checkInButton)
        self.addSubview(checkOutButton)
        self.addSubview(horizontalDivider)
        self.addSubview(callButton)
        self.addSubview(phoneNumberLable)
        self.addSubview(horizontalDivider1)
        self.addSubview(mapButton)
        self.addSubview(horizontalDivider2)
        self.addSubview(clockButton)
//        self.addSubview(operatingStatusLabel)
        self.addSubview(operatingTimeLabel)
//        self.addSubview(openOperatingTimeButton)
        self.addSubview(horizontalDivider3)
        self.addSubview(addressLabel)
        self.addSubview(alreadyCheckIn)
        setAttributes()
        guard let place = place else { return }
        mappingPlaceData(place)
    }
    
    private func setAttributes() {
        placeNameLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 40, paddingLeft: 20)
        distanceLabel.anchor(top: self.topAnchor, left: placeNameLabel.rightAnchor, paddingTop: 56, paddingLeft: 14)
        chekedinViewLabel.anchor(top: placeNameLabel.bottomAnchor, left: self.leftAnchor, paddingTop: 8, paddingLeft: 19)
        verticalDivider.anchor(top: placeNameLabel.bottomAnchor, left: chekedinViewLabel.rightAnchor, paddingTop: 11, paddingLeft: 35, width: 1, height: 15)
        questLabel.anchor(top: placeNameLabel.bottomAnchor, left: verticalDivider.rightAnchor, paddingTop: 8, paddingLeft: 35)
        horizontalDivider.anchor(top: checkInButton.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 16, paddingLeft: 20, paddingRight: 20, height: 1)
        callButton.anchor(top: horizontalDivider.bottomAnchor, left: self.leftAnchor, paddingTop: 7, paddingLeft: 27)
        phoneNumberLable.anchor(top: horizontalDivider.bottomAnchor, left: self.leftAnchor, paddingTop: 9, paddingLeft: 60)
        horizontalDivider1.anchor(top: horizontalDivider.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 34, paddingLeft: 20, paddingRight: 20, height: 1)
        mapButton.anchor(top: horizontalDivider1.bottomAnchor, left: self.leftAnchor, paddingTop: 7, paddingLeft: 27)
        addressLabel.anchor(top: horizontalDivider1.bottomAnchor, left: self.leftAnchor, paddingTop: 9, paddingLeft: 60)
        horizontalDivider2.anchor(top: horizontalDivider1.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 34, paddingLeft: 20, paddingRight: 20, height: 1)
        clockButton.anchor(top: horizontalDivider2.bottomAnchor, left: self.leftAnchor, paddingTop: 7, paddingLeft: 27)
//        operatingStatusLabel.anchor(top: horizontalDivider2.bottomAnchor, left: self.leftAnchor, paddingTop: 9, paddingLeft: 60)
        operatingTimeLabel.anchor(top: horizontalDivider2.bottomAnchor, left: self.leftAnchor, paddingTop: 9, paddingLeft: 60)
//        openOperatingTimeButton.anchor(top: horizontalDivider2.bottomAnchor, right: self.rightAnchor, paddingTop: 9, paddingRight: 38)
        horizontalDivider3.anchor(top: operatingTimeLabel.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 8, paddingLeft: 20, paddingRight: 20, height: 1)
        checkInButton.anchor(top: placeNameLabel.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 38, paddingLeft: 20, paddingRight: 20, height: 48)
        checkOutButton.anchor(top: placeNameLabel.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 38, paddingLeft: 20, paddingRight: 20, height: 48)
        alreadyCheckIn.anchor(top: placeNameLabel.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 38, paddingLeft: 20, paddingRight: 20, height: 48)
    }
    
    func mappingPlaceData(_ place: Place) {
        placeNameLabel.text = place.name
        addressLabel.text = place.address
        phoneNumberLable.text = place.contact
    }
//    @objc func openOrClose() {
//        if self.chevronDirection == "chevron.down" {
//            self.chevronDirection = "chevron.up"
//            self.openOperatingTimeButton.setImage(UIImage(systemName: "chevron.up")?.withTintColor(CustomColor.nomadGray1 ?? .blue, renderingMode: .alwaysOriginal), for: .normal)
//            self.operatingTimeLabel.numberOfLines = 0
//        } else if self.chevronDirection == "chevron.up" {
//            self.chevronDirection = "chevron.down"
//            self.openOperatingTimeButton.setImage(UIImage(systemName: "chevron.down")?.withTintColor(CustomColor.nomadGray1 ?? .blue, renderingMode: .alwaysOriginal), for: .normal)
//            self.operatingTimeLabel.numberOfLines = 1
//        } else { return }
//    }
}

