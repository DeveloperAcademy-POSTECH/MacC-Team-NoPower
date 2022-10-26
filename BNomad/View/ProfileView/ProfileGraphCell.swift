//
//  ProfileGraphCell.swift
//  BNomad
//
//  Created by Beone on 2022/10/19.
//

import UIKit


class ProfileGraphCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var thisCellsDate: String?
    var checkInHistory: [CheckIn]? {
        didSet {
            guard let checkInHistory = checkInHistory else { return
                
            }
            var checkInDates: [String] = []
            checkInDates = checkInHistory.compactMap { $0.date } //data에서 체크인한 날자만 맵핑
            
            if checkInDates.contains(thisCellsDate ?? "") {
            }
            
        }
    }
    
    static let identifier = "ProfileGraphCell"
    static var addedWeek: Int = 0
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = DummyData.place1.name
        label.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: [UILabel] = {
        var label:[UILabel] = []
        
        for index in 0...3 {
            let time = UILabel()
            time.text = String(9 + index*5) //FIXME: 그래프 간격 어떻게 할건지? 현재는 데이터 로직 기준
            time.textColor = .gray
            time.font = .preferredFont(forTextStyle: .caption2, weight: .regular)
            time.translatesAutoresizingMaskIntoConstraints = false
            label.append(time)
        }
        return label
    }()
    
    static var dayLabel: [UILabel] = {
        var label: [UILabel] = []
        
        for index in 0..<7 {
            let day = UILabel()
            day.text = Contents.dateLabelMaker()[index][3]
            day.textColor = .black
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d"
            if Contents.dateLabelMaker()[index][2] == formatter.string(from: Date()) {
                day.textColor = CustomColor.nomadGreen
            }
            
            day.font = .preferredFont(forTextStyle: .caption2, weight: .regular)
            day.translatesAutoresizingMaskIntoConstraints = false
            label.append(day)
        }
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
        
        let timeStack = UIStackView(arrangedSubviews: timeLabel)
        timeStack.axis = .vertical
        timeStack.spacing = 35
        timeStack.distribution = .fillEqually
        timeStack.translatesAutoresizingMaskIntoConstraints = false
        
        let dayStack = UIStackView(arrangedSubviews: ProfileGraphCell.dayLabel)
        dayStack.axis = .horizontal
        dayStack.spacing = 19
        dayStack.distribution = .fillEqually
        dayStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(timeStack)
        timeStack.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 10, paddingLeft: 10)
        
        contentView.addSubview(dayStack)
        dayStack.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 166, paddingLeft: 45)

    }
    
    static func editWeek(edit: Int) { //TODO: 로직 단순화 필요
        addedWeek = addedWeek + edit
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        for index in Contents.dateLabelMaker().indices {
            if Contents.dateLabelMaker()[index][2] == formatter.string(from:Date()) && addedWeek == 0 {
                dayLabel[index].textColor = CustomColor.nomadGreen
            } else {
                dayLabel[index].textColor = .black
            }
        }
    }
}
