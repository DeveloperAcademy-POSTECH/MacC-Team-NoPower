//
//  CalendarCell.swift
//  BNomad
//
//  Created by Beone on 2022/10/19.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var thisCellsDate: String?
    var checkInHistory: [CheckIn]? {
        didSet {
            guard let checkInHistory = checkInHistory else { return }
            var checkInDates: [String] = []
            checkInDates = checkInHistory.compactMap { $0.date } //data에서 체크인한 날자만 맵핑
            
            if checkInDates.contains(thisCellsDate ?? "") {                    self.drawCheckinStamp()
            }
            
        }
    }
    
    static let identifier = "CalendarCell"
    private lazy var dayLabel = UILabel()
    
    private lazy var stampImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.image = Contents.resizeImage(image: UIImage(named: "checkinStamp") ?? UIImage(), targetSize: CGSize(width: 34.0, height: 34.0))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()


    
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
        self.dayLabel.font = .systemFont(ofSize: 12, weight: .bold)
        
        self.dayLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.dayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.dayLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func setWeekendColor(){
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
        self.stampImage.removeFromSuperview()
    }
    
    func drawCheckinStamp() {
        self.addSubview(stampImage)
        self.stampImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.stampImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func setTodayCell() {
        self.dayLabel.textColor = .white
        self.backgroundColor = CustomColor.nomadSkyblue
        self.layer.cornerRadius = 20
    }

}
