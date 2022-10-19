//
//  ProfileViewCell.swift
//  BNomad
//
//  Created by Beone on 2022/10/18.
//

import UIKit

class SelfUserInfoCell: UICollectionViewCell {
    
    //MARK: -Properties
    
    static let identifier = "SelfUserInfoCell"
        
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = DummyData.user1.nickname
        label.font = .preferredFont(forTextStyle: .title1, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let jobLabel: UILabel = {
        let label = UILabel()
        label.text = "iOS Developer"
        label.textColor = .gray
        label.font = .preferredFont(forTextStyle: .body, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0 //TODO: 행간 늘이기
        label.text = "안녕하세요 반가워요 윌로우에요 ios 개발 하고있어요, 디자인에도 관심이 많아서 대화 나누기 좋아해요"
        label.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false

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

        contentView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        contentView.addSubview(jobLabel)
        jobLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60).isActive = true
        jobLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        jobLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        contentView.addSubview(statusLabel)
        statusLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 110).isActive = true
        statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
    }

}

