//
//  VisitingInfoCell.swift
//  BNomad
//
//  Created by Beone on 2022/10/19.
//

import UIKit

class VisitCardCell: UICollectionViewCell {
    
    static let identifier = "VisitingInfoCell"
    
    // MARK: - Properties
    
    var thisCellsDate: String?
    lazy var viewModel = CombineViewModel.shared
    
    var checkInHistory: CheckIn? {
        didSet {
            guard let checkInHistory = checkInHistory else {
                nilHistory()
                return
                
            }
            
            rectView.removeFromSuperview()
            nilLabel.removeFromSuperview()
            
            let place = self.viewModel.places.first {$0.placeUid == checkInHistory.placeUid}
            nameLabel.text = place?.name
            
            checkinCommentLabel.text = checkInHistory.todayGoal
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M월 d일"
            
            let checkinTime = dateFormatter.string(from: checkInHistory.checkInTime)
            self.checkinDateLabel.text = checkinTime
            
            
            dateFormatter.dateFormat = "HH:mm"
            let checkInTime = dateFormatter.string(from: checkInHistory.checkInTime)
            guard let checkOutTime = checkInHistory.checkOutTime else {
                //                self.layer.borderWidth = 2
                //                self.layer.borderColor = CustomColor.nomadBlue?.cgColor
                self.checkInAndOutLabel.text = checkInTime + " ~"
                return
            }
            //            self.layer.borderWidth = 0
            self.checkInAndOutLabel.text = checkInTime + " - " + dateFormatter.string(from: checkOutTime)
            
        }
    }
    
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        
        label.text = ""
        label.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        return label
    }()
    
    private let checkinDateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13)
        label.font = .preferredFont(forTextStyle: .headline, weight: .semibold)
        return label
    }()
    
    private let checkInAndOutLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = CustomColor.nomadGray1
        label.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
        return label
    }()
    
    private let checkinCommentLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 목표를 입력하면 여기에 나타납니다."
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = CustomColor.nomadBlack
        label.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
        return label
    }()
    
    private let rectView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let nilLabel: UILabel = {
        let label = UILabel()
        label.text = "방문기록이 없습니다."
        label.textColor = .gray
        label.font = .preferredFont(forTextStyle: .headline, weight: .semibold)
        
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
        nameLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 20, paddingRight: 20)
        
        contentView.addSubview(checkInAndOutLabel)
        checkInAndOutLabel.anchor(top: nameLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 2, paddingLeft: 20, paddingRight: 20)
        
        contentView.addSubview(checkinCommentLabel)
        checkinCommentLabel.anchor(top: checkInAndOutLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 2, paddingLeft: 20, paddingRight: 20)
        
    }
    
    func nilHistory() {
        contentView.addSubview(rectView)
        rectView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor)
        contentView.addSubview(nilLabel)
        nilLabel.centerX(inView: contentView)
        nilLabel.centerY(inView: contentView)
    }
    
    func eraseNilHistory() {
        rectView.removeFromSuperview()
        nilLabel.removeFromSuperview()
    }
    
}
