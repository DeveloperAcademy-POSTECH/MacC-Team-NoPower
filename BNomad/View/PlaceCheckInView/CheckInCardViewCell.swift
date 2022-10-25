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
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "윌성수"
        label.font = .preferredFont(forTextStyle: .title2, weight: .bold)
        label.textColor = CustomColor.nomadBlack
        
        return label
    }()

    private let userOccupationLabel: UILabel = {
        let label = UILabel()
        label.text = "iOS 개발자"
        label.font = .preferredFont(forTextStyle: .footnote, weight: .semibold)
        label.textColor = CustomColor.nomadGray1
        
        return label
    }()
    
    private let userStatusMessage: UILabel = {
        let label = UILabel()
        label.text = "학식 같이 드실분 연락주세요!"
        label.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
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
        label.text = "10:20 AM"
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
            paddingLeft: 18
        )
        
        self.addSubview(userOccupationLabel)
        userOccupationLabel.anchor(
            left: userNameLabel.rightAnchor,
            bottom: userNameLabel.bottomAnchor,
            paddingLeft: 20
        )
        
        self.addSubview(userStatusMessage)
        userStatusMessage.anchor(
            top: userNameLabel.bottomAnchor,
            left: userNameLabel.leftAnchor,
            paddingTop: 6
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
