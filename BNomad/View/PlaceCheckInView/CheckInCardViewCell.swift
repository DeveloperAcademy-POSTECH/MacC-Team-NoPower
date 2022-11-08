//
//  CheckInCardViewCell.swift
//  BNomad
//
//  Created by Eunbee Kang on 2022/10/24.
//

import UIKit

protocol CheckOutAlert {
    func checkOutAlert(place: Place)
}

class CheckInCardViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "checkInCardViewCell"
    
    var checkOutDelegate: CheckOutAlert?
    
    var viewModel = CombineViewModel.shared
    
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
    
    var selectedPlaceTitle: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline, weight: .regular)
        return label
    }()
    
    private let cardRectangleView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.nomadGray2
        view.layer.masksToBounds = false
        return view
    }()

    private let profileImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "person.circle.fill")
        view.tintColor = CustomColor.nomadGray2
        view.anchor(width: 80, height: 80)
        return view
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2, weight: .bold)
        label.textColor = CustomColor.nomadBlack
        label.numberOfLines = 1
        return label
    }()

    private lazy var userOccupationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline, weight: .semibold)
        label.textColor = CustomColor.nomadGray1
        return label
    }()
    
    private lazy var userStatusMessage: UILabel = {
        let label = UILabel()
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
        label.font = .preferredFont(forTextStyle: .body, weight: .semibold)
        label.textColor = CustomColor.nomadBlack
        return label
    }()
    
    private let userTimeSpentLabel: UILabel = {
        let label = UILabel()
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
        view.backgroundColor = CustomColor.nomadGray1
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
    
    private lazy var userProfileStack: UIStackView = {
        let userStatusStack = UIStackView(arrangedSubviews: [userNameLabel, userOccupationLabel])
        userStatusStack.alignment = .leading
        userStatusStack.axis = .vertical
        userStatusStack.spacing = 2
        
        let userStack = UIStackView(arrangedSubviews: [UIView(), userStatusStack, userStatusMessage])
        userStack.axis = .vertical
        userStack.spacing = 9
        userStack.alignment = .leading
        
        let wholeStack = UIStackView(arrangedSubviews: [profileImageView, userStack])
        wholeStack.alignment = .leading
        wholeStack.axis = .horizontal
        wholeStack.spacing = 12
        
        return wholeStack
    }()
    
    private lazy var spendingTimeStack: UIStackView = {
        let checkInStack = UIStackView(arrangedSubviews: [checkInLabel, checkInTimeLabel])
        checkInStack.axis = .vertical
        checkInStack.spacing = 3
        checkInStack.alignment = .leading
        
        let timeSpentStack = UIStackView(arrangedSubviews: [timeSpentLabel, userTimeSpentLabel])
        timeSpentStack.axis = .vertical
        timeSpentStack.spacing = 3
        timeSpentStack.alignment = .trailing
        
        let spacer = UIView()
        let wholeStack = UIStackView(arrangedSubviews: [checkInStack, spacer, timeSpentStack])
        spacer.anchor(left: checkInTimeLabel.rightAnchor, right: userTimeSpentLabel.leftAnchor)
        wholeStack.axis = .horizontal
        wholeStack.distribution = .fill
        
        return wholeStack
    }()
    
    private lazy var timeBarStack: UIStackView = {
        let spacer = UIView()
        let timeStack = UIStackView(arrangedSubviews: [startTimeLabel, spacer, endTimeLabel])
        spacer.anchor(left: startTimeLabel.rightAnchor, right: endTimeLabel.leftAnchor)
        timeStack.axis = .horizontal
        timeStack.distribution = .fill
        
        timeBar.addSubview(checkInTimeBar)
        checkInTimeBar.anchor(top: timeBar.topAnchor, left: timeBar.leftAnchor, bottom: timeBar.bottomAnchor, right: timeBar.rightAnchor, paddingLeft: 30, paddingRight: 30)
        timeBar.anchor(height: 10)
        let wholeStack = UIStackView(arrangedSubviews: [timeStack, timeBar])
        wholeStack.axis = .vertical
        
        return wholeStack
    }()
    
    private lazy var checkOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("체크아웃 하기", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body, weight: .bold)
        button.backgroundColor = CustomColor.nomadBlue
        button.layer.cornerRadius = 8
        button.tintColor = .white
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
        let checkOutPlace = viewModel.places.first { $0.placeUid == viewModel.user?.checkInHistory?.last?.placeUid }
        checkOutDelegate?.checkOutAlert(place: checkOutPlace!)
    }
    
    // MARK: - Methods
    
    func configUI() {
        let spacer = UIView()
        let stack = UIStackView(arrangedSubviews: [userProfileStack, spendingTimeStack, timeBarStack, checkOutButton, spacer])
        timeBarStack.anchor(top: spendingTimeStack.bottomAnchor, paddingTop: 15)
        spacer.anchor(height: 15)
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.spacing = 17
        
        self.addSubview(stack)
        stack.anchor(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 90, paddingLeft: 20, paddingRight: 20, height: 290)
        checkOutButton.anchor(height: 50)
        
        self.addSubview(selectedPlaceTitle)
        selectedPlaceTitle.anchor(bottom: stack.topAnchor, paddingBottom: 7)
        selectedPlaceTitle.centerX(inView: self)
    }
}
