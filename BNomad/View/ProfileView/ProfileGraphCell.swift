//
//  ProfileGraphCell.swift
//  BNomad
//
//  Created by Beone on 2022/10/19.
//

import UIKit


class ProfileGraphCell: UICollectionViewCell {
    
    //MARK: -Properties
    static let identifier = "ProfileGraphCell"
    
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
            time.text = String(9 + index*3)
            time.textColor = .gray
            time.font = .preferredFont(forTextStyle: .caption2, weight: .regular)
            time.translatesAutoresizingMaskIntoConstraints = false
            label.append(time)
        }
        return label
    }()
    
    //MARK: - init
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            render()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(corder:) has not been implemented")
        }
    
    func render() {

//        contentView.addSubview(nameLabel)
//        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25).isActive = true
//        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
//        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        let stack = [UIStackView(arrangedSubviews: timeLabel), UIStackView(arrangedSubviews: timeLabel)]
        
        stack[0].axis = .vertical
        stack[0].spacing = 31
        stack[0].distribution = .fillEqually
        
        contentView.addSubview(stack[0])
        stack[0].translatesAutoresizingMaskIntoConstraints = false
        stack[0].topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        stack[0].leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true


    }
    

}
