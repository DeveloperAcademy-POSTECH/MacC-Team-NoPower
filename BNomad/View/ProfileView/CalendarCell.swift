//
//  CalendarCell.swift
//  BNomad
//
//  Created by Beone on 2022/10/19.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var thisCellsDate: String? {
        didSet {
            guard let thisCellsDate = thisCellsDate else {
                return
            }
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "us")
            formatter.dateFormat = "yyyy-MM-dd"
            
            if thisCellsDate == formatter.string(from: Date()) {
                self.todayCircleView.backgroundColor = CustomColor.nomadBlue
                self.drawCircleBackground(opt: "today")
            }
        }
    }
    var checkInHistory: [CheckIn]? {
        didSet {
            guard let checkInHistory = checkInHistory else { return }
            var checkInDates: [String] = []
            checkInDates = checkInHistory.compactMap { $0.date } //data에서 체크인한 날자만 맵핑
            
            if checkInDates.contains(thisCellsDate ?? "") {
                self.drawCheckinStamp()
            }
            
        }
    }
    
    static let identifier = "CalendarCell"
    private lazy var dayLabel = UILabel()
    
    private lazy var stampDot: UIView = {
        let circleView = UIView(frame: CGRect(x: 358/16-1.5, y: 358/14+11, width: 3, height: 3))
        circleView.layer.cornerRadius = 1.5
        circleView.backgroundColor = UIColor(hex: "D9D9D9")
        circleView.tag = 101
        return circleView
    }()
    
     var todayCircleView: UIView {
         let circleView = UIView(frame: CGRect(x: 358/16-17, y: 358/14-17, width: 34, height: 34))
        circleView.layer.cornerRadius = 17
        circleView.backgroundColor = CustomColor.nomadBlue
        circleView.tag = 101
        return circleView
    }
    
    var SelectCircleView: UIView {
        let circleView = UIView(frame: CGRect(x: 358/16-17, y: 358/14-17, width: 34, height: 34))
       circleView.layer.cornerRadius = 17
       circleView.backgroundColor = CustomColor.nomadGray1
       circleView.tag = 101
       return circleView
   }
    
    

    
    //MARK: - init
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundColor = .white
            render()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(corder:) has not been implemented")
        }
    
    //MARK: - Actions
    
    func render() {
        
    }
    
    func configureLabel(text: String) {
        self.addSubview(dayLabel)
        self.dayLabel.text = text
        self.dayLabel.textColor = .black
        self.dayLabel.font = .preferredFont(forTextStyle: .footnote, weight: .semibold)
        
        self.dayLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.dayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.dayLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func setSundayColor(){
        self.dayLabel.textColor = CustomColor.nomadRed
    }
    
    func setSaturdayColor(){
        self.dayLabel.textColor = CustomColor.nomadSkyblue
    }
    
    func setSelectedCell() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 20
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func setNormalCell() {
        self.layer.borderWidth = 0
        self.backgroundColor = .white
        self.dayLabel.textColor = .black
        self.stampDot.removeFromSuperview()
        self.todayCircleView.removeFromSuperview()
    }
    
    func drawCheckinStamp() {
        self.addSubview(stampDot)
    }
    
    func setWhiteText() {
        self.dayLabel.textColor = .white
    }
    
    func drawCircleBackground(opt: String) {
        if opt == "today" {
            self.addSubview(todayCircleView)
        }else {
            self.addSubview(SelectCircleView)
        }
    }
    
    func removeTodayCell() {
        self.subviews.forEach {
            if $0.tag == 101 {
                $0.removeFromSuperview()
            }
        }
    }
}
