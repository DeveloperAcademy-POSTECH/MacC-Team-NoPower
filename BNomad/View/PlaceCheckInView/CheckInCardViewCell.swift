//
//  CheckInCardViewCell.swift
//  BNomad
//
//  Created by Eunbee Kang on 2022/10/24.
//

import UIKit

protocol pageDismiss {
    func checkOut()
}

class CheckInCardViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "checkInCardViewCell"
    
    var user: User? {
        didSet {
            userNameLabel.text = user?.nickname
            userOccupationLabel.text = user?.occupation
            userStatusMessage.text = user?.introduction
        }
    }
    
    var checkIn: CheckIn? {
        didSet {
            // 체크인 시간
            let startTime = checkIn?.checkInTime
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "hh:mm a"
            checkInTimeLabel.text = dateFormatter.string(from: startTime ?? Date())
            
            // 이용 시간
            // MARK: 최근 체크인 시간을 불러와서 24시간이 넘어갈 수 있음
            let current = Date()
            let timeInterval = current.timeIntervalSince(startTime ?? Date())
            let hour = Int(timeInterval / 3600)
            let minute = Int(timeInterval / 60) % 60
            userTimeSpentLabel.text = String(hour) + "시간" + String(minute) + "분"
            
            // 이용시간 상태바
            // MARK: 상태바가 표현할 정보 논의 후,
            // 운영시간 대비 이용시간 비율에 맞게 표시해야함
            
        }
    }
    
    var delegate: pageDismiss?
    
    private let cardRectangleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 3, height: 4)
        view.layer.shadowColor = CustomColor.nomadBlack?.cgColor
        view.layer.masksToBounds = false
        
        return view
    }()

    private let profileImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "person.circle.fill")
        view.tintColor = CustomColor.nomadGray2
        
        return view
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "김노마"
        label.font = .preferredFont(forTextStyle: .title2, weight: .bold)
        label.textColor = CustomColor.nomadBlack
        label.numberOfLines = 1
        
        return label
    }()

    private lazy var userOccupationLabel: UILabel = {
        let label = UILabel()
        label.text = "iOS 개발자"
        label.font = .preferredFont(forTextStyle: .footnote, weight: .semibold)
        label.textColor = CustomColor.nomadGray1
        
        return label
    }()
    
    private lazy var userStatusMessage: UILabel = {
        let label = UILabel()
        label.text = "디자인을 좋아하는 개발자입니다."
        label.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        label.numberOfLines = 1
        label.textColor = CustomColor.nomadGray1
        
        return label
    }()
    
    private let checkInLabel: UILabel = {
        let label = UILabel()
        label.text = "체크인"
        label.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        label.textColor = CustomColor.nomadBlack
        
        return label
    }()
    
    private let timeSpentLabel: UILabel = {
        let label = UILabel()
        label.text = "이용시간"
        label.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        label.textColor = CustomColor.nomadBlack
        
        return label
    }()
    
    private let checkInTimeLabel: UILabel = {
        let label = UILabel()
//        label.text = "10:20 AM"
        
        
        
        label.font = .preferredFont(forTextStyle: .body, weight: .semibold)
        
        label.textColor = CustomColor.nomadBlack
        
        return label
    }()
    
    private let userTimeSpentLabel: UILabel = {
        let label = UILabel()
        label.text = "3시간 40분"
        label.font = .preferredFont(forTextStyle: .body, weight: .semibold)
        label.textColor = CustomColor.nomadBlack
        
        return label
    }()
    
    private let startTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "9:00"
        label.font = .preferredFont(forTextStyle: .caption2, weight: .regular)
        label.textColor = CustomColor.nomadGray1
        
        return label
    }()
    
    private let endTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "22:00"
        label.font = .preferredFont(forTextStyle: .caption2, weight: .regular)
        label.textColor = CustomColor.nomadGray1
        
        return label
    }()
    
    private let timeBar: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.nomadGray2
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    private let checkInTimeBar: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.nomadBlue
        view.tintColor = CustomColor.nomadBlue
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    private lazy var checkOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("체크아웃 하기", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body, weight: .bold)
        button.backgroundColor = .white
        button.layer.borderColor = CustomColor.nomadBlue?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.tintColor = CustomColor.nomadBlue
        button.addTarget(self, action: #selector(checkOutTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(corder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func checkOutTapped() {
        delegate?.checkOut()
    }
    
    // MARK: - Methods
    
    func configUI() {
        
        self.addSubview(cardRectangleView)
        cardRectangleView.anchor(
            top: self.topAnchor,
            left: self.leftAnchor,
            bottom: self.bottomAnchor,
            right: self.rightAnchor,
            paddingTop: 5,
            paddingLeft: 20,
            paddingBottom: 25,
            paddingRight: 20,
            height: 266
        )
        
        self.addSubview(profileImageView)
        profileImageView.anchor(
            top: cardRectangleView.topAnchor,
            left: cardRectangleView.leftAnchor,
            paddingTop: 20,
            paddingLeft: 17,
            width: 64,
            height: 64
        )
        
        self.addSubview(userNameLabel)
        userNameLabel.anchor(
            top: cardRectangleView.topAnchor,
            left: profileImageView.rightAnchor,
            paddingTop: 28,
            paddingLeft: 18,
            width: 150
            
        )
        
        self.addSubview(userOccupationLabel)
        userOccupationLabel.anchor(
            left: userNameLabel.rightAnchor,
            bottom: userNameLabel.bottomAnchor,
            right: cardRectangleView.rightAnchor,
            paddingLeft: 20,
            paddingRight: 20
        )
        
        self.addSubview(userStatusMessage)
        userStatusMessage.anchor(
            top: userNameLabel.bottomAnchor,
            left: userNameLabel.leftAnchor,
            right: self.rightAnchor,
            paddingTop: 6,
            paddingRight: 20
        )
        
        self.addSubview(checkInLabel)
        checkInLabel.anchor(
            top: profileImageView.bottomAnchor,
            left: cardRectangleView.leftAnchor,
            paddingTop: 18,
            paddingLeft: 22
        )
        
        self.addSubview(timeSpentLabel)
        timeSpentLabel.anchor(
            top: checkInLabel.topAnchor,
            left: cardRectangleView.leftAnchor,
            paddingLeft: 197)
        
        self.addSubview(checkInTimeLabel)
        checkInTimeLabel.anchor(
            top: checkInLabel.bottomAnchor,
            left: checkInLabel.leftAnchor,
            paddingTop: 4
        )
        
        self.addSubview(userTimeSpentLabel)
        userTimeSpentLabel.anchor(
            top: checkInTimeLabel.topAnchor,
            left: timeSpentLabel.leftAnchor
        )
        
        self.addSubview(startTimeLabel)
        startTimeLabel.anchor(
            top: checkInTimeLabel.bottomAnchor,
            left: checkInLabel.leftAnchor,
            paddingTop: 18,
            width: 100
        )
        
        self.addSubview(endTimeLabel)
        endTimeLabel.anchor(
            top: userTimeSpentLabel.bottomAnchor,
            right: cardRectangleView.rightAnchor,
            paddingTop: 18,
            paddingRight: 22
        )
        
        self.addSubview(timeBar)
        timeBar.anchor(
            top: startTimeLabel.bottomAnchor,
            left: cardRectangleView.leftAnchor,
            right: cardRectangleView.rightAnchor,
            paddingTop: 4,
            paddingLeft: 22,
            paddingRight: 22,
            height: 8
        )
        
        self.addSubview(checkInTimeBar)
        checkInTimeBar.anchor(
            top: timeBar.topAnchor,
            left: timeBar.leftAnchor,
            bottom: timeBar.bottomAnchor,
            right: timeBar.rightAnchor,
            paddingLeft: 30,
            paddingRight: 100
        )
        
        self.addSubview(checkOutButton)
        checkOutButton.anchor(
            top: timeBar.bottomAnchor,
            left: cardRectangleView.leftAnchor,
            bottom: cardRectangleView.bottomAnchor,
            right: cardRectangleView.rightAnchor,
            paddingTop: 13,
            paddingLeft: 22,
            paddingBottom: 16,
            paddingRight: 22
        )
    }
}
