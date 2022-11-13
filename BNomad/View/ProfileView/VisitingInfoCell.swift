//
//  VisitingInfoCell.swift
//  BNomad
//
//  Created by Beone on 2022/10/19.
//

import UIKit

class VisitingInfoCell: UICollectionViewCell {
    
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
            dateFormatter.dateFormat = "HH:mm"

            let checkinTime = dateFormatter.string(from: checkInHistory.checkInTime)
            self.checkinTimeLabel.text = checkinTime
            
            let stayedTime = Int((checkInHistory.checkOutTime?.timeIntervalSince(checkInHistory.checkInTime) ?? 0) / 60)
            self.stayedTimeLabel.text = String(Int(stayedTime/60))+"시간"+String(stayedTime%60)+"분"

        }
    }
    
    var checkInHistoryForCalendar: CheckIn? {
        didSet {
            guard let checkInHistory = checkInHistoryForCalendar else { return }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
                    let checkinTime = dateFormatter.string(from: checkInHistory.checkInTime)
                    self.checkinTimeLabel.text = checkinTime
                    
                    let stayedTime = Int((checkInHistory.checkOutTime?.timeIntervalSince(checkInHistory.checkInTime) ?? 0) / 60)
                    self.stayedTimeLabel.text = String(Int(stayedTime/60))+"시간"+String(stayedTime%60)+"분"
                

            let place = self.viewModel.places.first {$0.placeUid == checkInHistory.placeUid}
            nameLabel.text = place?.name
        }
    }

    
    var checkInHistoryForProfile: [CheckIn]? {
        didSet {
            viewOption = "profile"
            guard let lastCheckIn = checkInHistoryForProfile?.last else {return}
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            let checkinTime = dateFormatter.string(from: lastCheckIn.checkInTime)
            self.checkinTimeLabel.text = checkinTime
            
            let stayedTime = Int((lastCheckIn.checkOutTime?.timeIntervalSince(lastCheckIn.checkInTime) ?? 0) / 60)
            self.stayedTimeLabel.text = String(Int(stayedTime/60))+"시간"+String(stayedTime%60)+"분"
            
            nameLabel.reloadInputViews()
        }
    }
    static let identifier = "VisitingInfoCell"
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        
        if viewOption == "calendar" {
            let lastCheckIn = self.viewModel.user?.checkInHistory?.first {$0.date == thisCellsDate ?? ""}
            let place = self.viewModel.places.first {$0.placeUid == lastCheckIn?.placeUid}
            label.text = place?.name
        }else {
            let lastCheckIn = self.viewModel.user?.checkInHistory?.last
            let place = self.viewModel.places.first {$0.placeUid == lastCheckIn?.placeUid}
            label.text = place?.name
        }
        
        label.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let checkinLabel: UILabel = {
        let label = UILabel()
        label.text = "체크인"
        label.textColor = .gray
        label.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stayedLabel: UILabel = {
        let label = UILabel()
        label.text = "이용시간"
        label.textColor = .gray
        label.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let checkinTimeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 13)
        label.font = .preferredFont(forTextStyle: .headline, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stayedTimeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 13)
        label.font = .preferredFont(forTextStyle: .headline, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        nameLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 25, paddingLeft: 20, paddingRight: 20)
        
        let stack = [UIStackView(arrangedSubviews: [checkinLabel, checkinTimeLabel]), UIStackView(arrangedSubviews: [stayedLabel, stayedTimeLabel])]
        stack.forEach {
            $0.axis = .vertical
            $0.spacing = 1
            $0.distribution = .fillEqually
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.addSubview(stack[0])
        stack[0].anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 60, paddingLeft: 20)
        
        contentView.addSubview(stack[1])
        stack[1].anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 60, paddingLeft: 200)
        
    }
    
}
