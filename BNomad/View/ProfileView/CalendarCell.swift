//
//  CalendarCell.swift
//  BNomad
//
//  Created by Beone on 2022/10/19.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "CalendarCell"
    private lazy var dayLabel = UILabel()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(corder:) has not been implemented")
    }
    
    // MARK: - Actions
    
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
    }
    
}
