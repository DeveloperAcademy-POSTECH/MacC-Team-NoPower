//
//  ParticipantCell.swift
//  BNomad
//
//  Created by Eunbee Kang on 2022/11/07.
//

import UIKit
import Kingfisher

class ParticipantCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ParticipantCell"
    
    var userUid: String? {
        didSet {
            guard let userUid = userUid else { return }
            FirebaseManager.shared.fetchUser(id: userUid) { user in
                self.nicknameLabel.text = user.nickname
                if let profileImageUrl = user.profileImageUrl {
                    self.profileImageView.kf.setImage(with: URL(string: profileImageUrl))
                } else {
                    self.profileImageView.image = UIImage(systemName: "person.crop.circle.fill")
                }
            }
            
            if organizerUid == userUid {
                crownView.isHidden = false
            } else {
                crownView.isHidden = true
            }
        }
    }
    
    var organizerUid: String?
    
    private let crownView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "crown.fill")
        image.tintColor = CustomColor.nomadYellow
        
        return image
    }()
    
    private let profileImageView: UIImageView = {
        let image = UIImageView()
        image.tintColor = CustomColor.nomadGray1
        image.clipsToBounds = true
        
        return image
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
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
        
        let screenWidth = UIScreen.main.bounds.width
        let profileImageSize = screenWidth * 58/390
        
        self.addSubview(profileImageView)
        profileImageView.anchor(top: crownView.bottomAnchor, paddingTop: 8, width: profileImageSize, height: profileImageSize)
        profileImageView.centerX(inView: self)
        profileImageView.layer.cornerRadius = profileImageSize / 2
        
        self.addSubview(nicknameLabel)
        nicknameLabel.anchor(top: profileImageView.bottomAnchor, paddingTop: 14)
        nicknameLabel.centerX(inView: self)
    }
}
