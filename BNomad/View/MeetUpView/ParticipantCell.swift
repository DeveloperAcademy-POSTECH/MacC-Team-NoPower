//
//  ParticipantCell.swift
//  BNomad
//
//  Created by Eunbee Kang on 2022/11/07.
//

import UIKit

class ParticipantCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ParticipantCell"
    
    private let crownView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "crown.fill")
        image.tintColor = CustomColor.nomadYellow
        
        return image
    }()
    
    private let profileImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.crop.circle.fill")
        image.tintColor = CustomColor.nomadGray1
        
        return image
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "윌성수성수상"
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = CustomColor.nomadBlack
        
        return label
    }()

    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(corder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configUI() {
        
        self.addSubview(crownView)
        crownView.anchor(top: self.topAnchor, width: 22, height: 18)
        crownView.centerX(inView: self)
        
        self.addSubview(profileImageView)
        profileImageView.anchor(top: crownView.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 8, paddingLeft: 7, paddingRight: 7)
        profileImageView.heightAnchor.constraint(equalTo: self.profileImageView.widthAnchor, multiplier: 1.0/1.0).isActive = true
        
        self.addSubview(nicknameLabel)
        nicknameLabel.anchor(top: profileImageView.bottomAnchor, paddingTop: 14)
        nicknameLabel.centerX(inView: self)
    }
}
