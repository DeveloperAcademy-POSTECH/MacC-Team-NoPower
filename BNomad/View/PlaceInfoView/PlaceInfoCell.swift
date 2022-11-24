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
    func afterCheckInTapped()
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
            FirebaseManager.shared.fetchMeetUpHistory(placeUid: place.placeUid) { meetUpList in
                self.todayMeetUpList = meetUpList
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
            self.checkedinViewLabel.text = "\(history.count)명의 노마드"
            let fullText = checkedinViewLabel.text ?? ""
            let attribtuedString = NSMutableAttributedString(string: fullText)
            let range = (fullText as NSString).range(of: "\(history.count)명")
            attribtuedString.addAttribute(.foregroundColor, value: CustomColor.nomadBlue as Any, range: range)
            checkedinViewLabel.attributedText = attribtuedString
        }
    }
    
    
    var todayMeetUpList: [MeetUp]? {
        didSet {
            guard let todayMeetUpList = todayMeetUpList else { return }
            self.numberOfMeetUp.text = "\(todayMeetUpList.count)개의 밋업"
            self.numberOfMeetUp.asColor(targetString: "\(todayMeetUpList.count)개", color: CustomColor.nomadBlue ?? .label)
        }
    }
        
    lazy var headerStack: UIStackView = {
        
        let placeDistanceStack = UIStackView(arrangedSubviews: [placeNameLabel, distanceLabel])
        placeDistanceStack.axis = .horizontal
        placeDistanceStack.alignment = .bottom
        placeDistanceStack.spacing = 10
        placeDistanceStack.distribution = .fillProportionally
       
        let nomadMeetUpStack = UIStackView(arrangedSubviews: [checkedinViewLabel, dotDivider, numberOfMeetUp])
        nomadMeetUpStack.axis = .horizontal
        nomadMeetUpStack.alignment = .center
        nomadMeetUpStack.spacing = 8
        nomadMeetUpStack.distribution = .fillProportionally
        
        let headerStack = UIStackView(arrangedSubviews: [placeDistanceStack, nomadMeetUpStack])
        headerStack.axis = .vertical
        headerStack.alignment = .top
        headerStack.spacing = 5


        return headerStack
    }()
    
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
    
    lazy var checkedinViewLabel: UILabel = {
        let UILabel = UILabel()
        UILabel.textColor = CustomColor.nomadBlack
        UILabel.font = .preferredFont(forTextStyle: .body, weight: .regular)
        return UILabel
    }()
    
    let dotDivider: UIView = {
        let dotDivider = UIView()
        dotDivider.backgroundColor = CustomColor.nomad2Separator
        dotDivider.layer.cornerRadius = 3
        dotDivider.anchor(width: 6, height: 6)

        
        return dotDivider
    }()
    
    lazy var numberOfMeetUp: UILabel = {
        let numberOfMeetUp = UILabel()
        numberOfMeetUp.textColor = CustomColor.nomadBlack
        numberOfMeetUp.font = .preferredFont(forTextStyle: .body, weight: .regular)
        let fullText = numberOfMeetUp.text ?? ""
        let attribtuedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "5개")
        attribtuedString.addAttribute(.foregroundColor, value: CustomColor.nomadBlue as Any, range: range)
        numberOfMeetUp.attributedText = attribtuedString
        
        return numberOfMeetUp
    }()
    
    lazy var checkInButton: UIButton = {
        var button = UIButton()
        button.setTitle("체크인 하기", for: .normal)
        button.tintColor = .white
        button.backgroundColor = CustomColor.nomadBlue
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .preferredFont(forTextStyle: .body, weight: .bold)
        button.addTarget(self, action: #selector(checkInTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var afterCheckInButton: UIButton = {
        var button = UIButton()
        button.setTitle("이곳에 체크인 중", for: .normal)
        button.setTitleColor(CustomColor.nomadBlue, for: .normal)
        button.tintColor = CustomColor.nomadBlue
        button.backgroundColor = CustomColor.nomad2White
        button.layer.borderWidth = 1
        button.layer.borderColor = CustomColor.nomadBlue?.cgColor
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .preferredFont(forTextStyle: .body, weight: .bold)
        button.addTarget(self, action: #selector(afterCheckInTapped), for: .touchUpInside)
        return button
    }()
    
    private let alreadyCheckIn: UIView = {
        let alreadyView = UIView()
        let label = UILabel()
        label.text = "다른 노마드스팟에 체크인 중"
        label.textColor = CustomColor.nomadGray1
        label.font = .preferredFont(forTextStyle: .body, weight: .bold)
        alreadyView.addSubview(label)
        label.centerX(inView: alreadyView)
        label.centerY(inView: alreadyView)
        alreadyView.backgroundColor = CustomColor.nomadGray2
        alreadyView.layer.cornerRadius = 8
        return alreadyView
    }()
    
    lazy var bodyStack : UIStackView = {
        
        let callStack = UIStackView(arrangedSubviews: [callButton, phoneNumberLabel])
        callStack.axis = .horizontal
        callStack.alignment = .leading
        callStack.spacing = 13
        callStack.distribution = .equalSpacing
        
        let mapStack = UIStackView(arrangedSubviews: [mapButton, addressLabel])
        mapStack.axis = .horizontal
        mapStack.alignment = .leading
        mapStack.spacing = 13
        mapStack.distribution = .equalSpacing
        
        let clockStack = UIStackView(arrangedSubviews: [clockButton, operatingTimeLabel])
        clockStack.axis = .horizontal
        clockStack.alignment = .leading
        clockStack.spacing = 13
        clockStack.distribution = .equalSpacing
        
        let bodyStack = UIStackView(arrangedSubviews: [callStack, horizontalDivider, mapStack, horizontalDivider1, clockStack])
        bodyStack.axis = .vertical
        bodyStack.alignment = .leading
        bodyStack.spacing = 8
        bodyStack.distribution = .fill
        
        return bodyStack
        
    }()

    let callButton: UIButton = {
        let callButton = UIButton()
        callButton.setImage(UIImage(systemName: "phone"), for: .normal)
        callButton.setPreferredSymbolConfiguration(.init(pointSize: 19, weight: .regular, scale: .default), forImageIn: .normal)
        callButton.tintColor = CustomColor.nomadBlack
        return callButton
    }()
    let phoneNumberLabel: UILabel = {
        let phoneNumberLabel = UILabel()
        phoneNumberLabel.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .regular)
        phoneNumberLabel.textColor = CustomColor.nomadBlack
        return phoneNumberLabel
    }()
        
    let horizontalDivider: UILabel = {
        let horizontalDivider = UILabel()
        horizontalDivider.backgroundColor = CustomColor.nomad2Separator
        return horizontalDivider
    }()
    
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
        addressLable.numberOfLines = 0
        addressLable.lineBreakMode = .byWordWrapping
        return addressLable
    }()
    
    let horizontalDivider1: UILabel = {
        let horizontalDivider1 = UILabel()
        horizontalDivider1.backgroundColor = CustomColor.nomad2Separator
        return horizontalDivider1

    }()
    let clockButton: UIButton = {
        let clockButton = UIButton()
        clockButton.setImage(UIImage(systemName: "clock"), for: .normal)
        clockButton.setPreferredSymbolConfiguration(.init(pointSize: 19, weight: .regular, scale: .default), forImageIn: .normal)
        clockButton.tintColor = CustomColor.nomadBlack
        return clockButton
    }()
    
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
                    self.afterCheckInButton.isHidden = true
                    self.alreadyCheckIn.isHidden = true
                } else {
                    guard let user = user else { return }
                    if user.isChecked && self.place?.placeUid == user.currentCheckIn?.placeUid {
                        self.checkInButton.isHidden = true
                        self.afterCheckInButton.isHidden = false
                        self.alreadyCheckIn.isHidden = true
                    } else if user.isChecked && self.place?.placeUid != user.currentCheckIn?.placeUid {
                        self.checkInButton.isHidden = true
                        self.afterCheckInButton.isHidden = true
                        self.alreadyCheckIn.isHidden = false
                    } else {
                        self.checkInButton.isHidden = false
                        self.afterCheckInButton.isHidden = true
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
    
    @objc func afterCheckInTapped() {
        delegate?.afterCheckInTapped()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        self.addSubview(headerStack)
        self.addSubview(checkInButton)
        self.addSubview(afterCheckInButton)
        self.addSubview(bodyStack)
        horizontalDivider.anchor(left: bodyStack.leftAnchor, right: bodyStack.rightAnchor, height: 1)
        horizontalDivider1.anchor(left: bodyStack.leftAnchor, right: bodyStack.rightAnchor, height: 1)
        self.addSubview(alreadyCheckIn)
        setAttributes()
        guard let place = place else { return }
        mappingPlaceData(place)
    }
    
    private func setAttributes() {
        headerStack.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 40, paddingLeft: 20)
        bodyStack.anchor(top: checkInButton.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 23, paddingLeft: 27, paddingRight: 27)
        checkInButton.anchor(top: headerStack.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20, height: 48)
        afterCheckInButton.anchor(top: headerStack.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20, height: 48)
        alreadyCheckIn.anchor(top: headerStack.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20, height: 48)
    }
    
    func mappingPlaceData(_ place: Place) {
        placeNameLabel.text = place.name
        addressLabel.text = place.address
        phoneNumberLabel.text = place.contact
    }
}

