//
//  ProfileViewCell.swift
//  BNomad
//
//  Created by Beone on 2022/10/18.
//

import UIKit
import SwiftUI

class ProfileViewCell1: UICollectionViewCell {
    
    //MARK: -Properties
    
    static let identifier = "CollectionViewCell1"
        
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


class ProfileViewCell2: UICollectionViewCell {
    
    //MARK: -Properties
    static let identifier = "CollectionViewCell2"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = DummyData.place1.name
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
        label.text = "10:30"
        label.font = UIFont.systemFont(ofSize: 13)
        label.font = .preferredFont(forTextStyle: .headline, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stayedTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "1시간 20분"
        label.font = UIFont.systemFont(ofSize: 13)
        label.font = .preferredFont(forTextStyle: .headline, weight: .semibold)
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
        
        let stack = [UIStackView(arrangedSubviews: [checkinLabel, checkinTimeLabel]), UIStackView(arrangedSubviews: [stayedLabel, stayedTimeLabel])]
        stack.forEach {
            $0.axis = .vertical
            $0.spacing = 1
            $0.distribution = .fillEqually
        }
        
        contentView.addSubview(stack[0])
        stack[0].translatesAutoresizingMaskIntoConstraints = false
        stack[0].topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60).isActive = true
        stack[0].leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        
        contentView.addSubview(stack[1])
        stack[1].translatesAutoresizingMaskIntoConstraints = false
        stack[1].topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60).isActive = true
        stack[1].leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 200).isActive = true


    }
    

}

