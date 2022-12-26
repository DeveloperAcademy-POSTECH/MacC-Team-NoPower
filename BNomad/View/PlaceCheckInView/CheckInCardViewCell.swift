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
    
    private enum Value {
        static let paddingLeftRight: CGFloat = 20.0
        static let dayInMinutes: CGFloat = 1440.0
    }
    
    var user: User? {
        didSet {
            userNameLabel.text = user?.nickname
            userOccupationLabel.text = user?.occupation
            userStatusMessage.text = user?.currentCheckIn?.todayGoal
            if let profileImageUrl = user?.profileImageUrl {
                self.profileImageView.kf.setImage(with: URL(string: profileImageUrl))
            }
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

            // 프로그래스바
            var midnight: Date {
                let cal = Calendar(identifier: .gregorian)
                guard let checkInTime = checkIn?.checkInTime else { return Date() }
                return cal.startOfDay(for: checkInTime)
            }
            guard let startTime = startTime else { return }
            let checkInTimeInterval = startTime.timeIntervalSince(midnight)
            let checkInTimeInMinutes = checkInTimeInterval / 60
            let timeSpentInMinutes = timeInterval / 60

            let timeBarWidth = self.bounds.width - (Value.paddingLeftRight * 2)
            let checkInTimeBarPaddingLeft = timeBarWidth * checkInTimeInMinutes / Value.dayInMinutes
            let checkInTimeBarPaddingRight = timeBarWidth * (1 - (checkInTimeInMinutes + timeSpentInMinutes) / Value.dayInMinutes )
            
            timeBar.addSubview(checkInTimeBar)
            checkInTimeBar.anchor(top: timeBar.topAnchor, left: timeBar.leftAnchor, bottom: timeBar.bottomAnchor, right: timeBar.rightAnchor, paddingLeft: checkInTimeBarPaddingLeft, paddingRight: checkInTimeBarPaddingRight)
        }
    }
    
    private let cardRectangleView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.nomad2White
        view.layer.borderWidth = 0.5
        view.layer.borderColor = CustomColor.nomadGray2?.cgColor
        return view
    }()

    private let profileImageView: ProfileUIImageView = {
        let imageView = ProfileUIImageView(widthToRadius: 80)
        imageView.anchor(width: 80, height: 80)
        imageView.tintColor = CustomColor.nomadGray2
        return imageView
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
        label.text = "00:00"
        label.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        label.textColor = CustomColor.nomadGray1
        return label
    }()
    
    private let endTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "24:00"
        label.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
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
        
        timeBar.anchor(height: 8)
        let wholeStack = UIStackView(arrangedSubviews: [timeStack, timeBar])
        wholeStack.axis = .vertical
        wholeStack.spacing = 4
        
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
        
        self.addSubview(cardRectangleView)
        cardRectangleView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingBottom: 20)
        
        self.addSubview(stack)
        stack.anchor(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 90, paddingLeft: Value.paddingLeftRight, paddingRight: Value.paddingLeftRight, height: 290)
        checkOutButton.anchor(height: 50)
    }
}
