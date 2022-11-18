//
//  VisitingInfoCell.swift
//  BNomad
//
//  Created by Beone on 2022/10/19.
//

import UIKit

class VisitCardCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var thisCellsDate: String?
    var cardDataList: [CheckIn] = []
    var viewOption: String = ""
    lazy var viewModel = CombineViewModel.shared
    
    var checkinHistoryForList: CheckIn? {
        didSet {
            guard let checkInHistory = checkinHistoryForList else { return }
            let place = self.viewModel.places.first {$0.placeUid == checkInHistory.placeUid}
            nameLabel.text = place?.name
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M월 d일"
            
            dateFormatter.dateFormat = "HH:mm"
            let checkInTime = dateFormatter.string(from: checkInHistory.checkInTime)
            let checkOutTime = dateFormatter.string(from: checkInHistory.checkOutTime ?? Date())
            self.checkInAndOutLabel.text = checkInTime + " - " + checkOutTime

            let checkinTime = dateFormatter.string(from: checkInHistory.checkInTime)
            self.checkinDateLabel.text = checkinTime
            
            let stayedTime = Int((checkInHistory.checkOutTime?.timeIntervalSince(checkInHistory.checkInTime) ?? 0) / 60)
            self.stayedTimeLabel.text = String(Int(stayedTime/60))+"시간"+String(stayedTime%60)+"분"

        }
    }
    
    var checkInHistoryForCalendar: CheckIn? {
        didSet {
            guard let checkInHistory = checkInHistoryForCalendar else { return }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M월 d일"
            
            let checkinTime = dateFormatter.string(from: checkInHistory.checkInTime)
            self.checkinDateLabel.text = checkinTime
            
            dateFormatter.dateFormat = "HH:mm"
            let checkInTime = dateFormatter.string(from: checkInHistory.checkInTime)
            let checkOutTime = dateFormatter.string(from: checkInHistory.checkOutTime ?? Date())
            self.checkInAndOutLabel.text = checkInTime + " - " + checkOutTime
                    
            let stayedTime = Int((checkInHistory.checkOutTime?.timeIntervalSince(checkInHistory.checkInTime) ?? 0) / 60)
            self.stayedTimeLabel.text = String(Int(stayedTime/60))+"시간"+String(stayedTime%60)+"분"
                

            let place = self.viewModel.places.first {$0.placeUid == checkInHistory.placeUid}
            nameLabel.text = place?.name
        }
    }

    
    var checkInHistoryForProfile: [CheckIn]? {
        didSet {
            viewOption = "profile"
            guard let lastCheckIn = checkInHistoryForProfile?.last else {
                nameLabel.text = "최근 방문한 장소가 없습니다"
                return
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M월 d일"
            
            let checkinTime = dateFormatter.string(from: lastCheckIn.checkInTime)
            self.checkinDateLabel.text = checkinTime
            
            dateFormatter.dateFormat = "HH:mm"
            let checkInTime = dateFormatter.string(from: lastCheckIn.checkInTime)
            let checkOutTime = dateFormatter.string(from: lastCheckIn.checkOutTime ?? Date())
            self.checkInAndOutLabel.text = checkInTime + " - " + checkOutTime
            
            let stayedTime = Int((lastCheckIn.checkOutTime?.timeIntervalSince(lastCheckIn.checkInTime) ?? 0) / 60)
            self.stayedTimeLabel.text = String(Int(stayedTime/60))+"시간"+String(stayedTime%60)+"분"
            
            nameLabel.reloadInputViews()
        }
    }
    static let identifier = "VisitingInfoCell"
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        
        if viewOption != "calendar" {
            let lastCheckIn = self.viewModel.user?.checkInHistory?.last
            let place = self.viewModel.places.first {$0.placeUid == lastCheckIn?.placeUid}
            label.text = place?.name
        }
        
        label.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        return label
    }()
    
    private let checkinDateHeadLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜"
        label.textColor = .gray
        label.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
        return label
    }()
    
    private let stayedTimeHeadLabel: UILabel = {
        let label = UILabel()
        label.text = "이용시간"
        label.textColor = .gray
        label.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
        return label
    }()
    
    private let checkinDateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 13)
        label.font = .preferredFont(forTextStyle: .headline, weight: .semibold)
        return label
    }()
    
    private let stayedTimeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 13)
        label.font = .preferredFont(forTextStyle: .headline, weight: .semibold)
        return label
    }()
    
    private let checkInAndOutLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        label.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
        return label
    }()
    
    private let dividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.nomadGray1
        view.layer.masksToBounds = false

        return view
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(corder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func render() {
        
        contentView.addSubview(nameLabel)
        nameLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 20, paddingRight: 20)
        
        contentView.addSubview(checkInAndOutLabel)
        checkInAndOutLabel.anchor(top: nameLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 2, paddingLeft: 20, paddingRight: 20)
        
        let stack = [UIStackView(arrangedSubviews: [checkinDateHeadLabel, checkinDateLabel]), UIStackView(arrangedSubviews: [stayedTimeHeadLabel, stayedTimeLabel])]
        stack.forEach {
            $0.axis = .vertical
            $0.spacing = 1
            $0.distribution = .fillEqually
            $0.alignment = .center
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.addSubview(stack[0])
        stack[0].anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 68, paddingLeft: 50)
        
        contentView.addSubview(stack[1])
        stack[1].anchor(top: contentView.topAnchor, right: contentView.rightAnchor, paddingTop: 68, paddingRight: 50)
        
        contentView.addSubview(dividerLine)
        dividerLine.anchor(top: contentView.topAnchor, paddingTop: 72, width: 1, height: 31)
        dividerLine.centerX(inView: contentView)
        
    }
    
}
