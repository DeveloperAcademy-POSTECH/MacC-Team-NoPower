//
//  CheckedProfileListViewCell.swift
//  BNomad
//
//  Created by yeekim on 2022/10/19.
//

import UIKit
import Kingfisher

class CheckedProfileListViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "CheckedProfileListViewCell"
    
    var userUid: String? {
        didSet {
            guard let userUid = userUid else { return }
            FirebaseManager.shared.fetchUser(id: userUid) { user in
                self.user = user
            }
        }
    }
    
    var todayGoal: String? {
        didSet {
            guard let todayGoal = todayGoal else { return }
            noteLabel.text = todayGoal
        }
    }
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            usernameLabel.text = user.nickname
            occupationLabel.text = user.occupation
            if let profileImageUrl = user.profileImageUrl {
                self.userProfileImg.kf.setImage(with: URL(string: profileImageUrl))
            } else {
                self.userProfileImg.image = UIImage(systemName: "person.circle.fill")
            }
        }
    }
    
    private let userProfileImg: UIImageView = {
        let userProfileImg = UIImageView()
        userProfileImg.tintColor = CustomColor.nomadGray2
        userProfileImg.translatesAutoresizingMaskIntoConstraints = false
        userProfileImg.clipsToBounds = true
        userProfileImg.contentMode = .scaleAspectFill
        return userProfileImg
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    private let occupationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
        label.textColor = CustomColor.nomadGray1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
        shadowSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(corder:) has not been implemented")
    }
    
    func render() {
        self.addSubview(userProfileImg)
        userProfileImg.anchor(left: self.leftAnchor, paddingLeft: 14, width: 50, height: 50)
        userProfileImg.centerY(inView: self)
        userProfileImg.layer.cornerRadius = 50/2
        
        let nameJobStack = UIStackView(arrangedSubviews: [usernameLabel, occupationLabel])
        nameJobStack.axis = .horizontal
        nameJobStack.distribution = .fill
        nameJobStack.alignment = .firstBaseline
        nameJobStack.spacing = 10
        self.addSubview(nameJobStack)
        nameJobStack.anchor(top: self.topAnchor, left: userProfileImg.rightAnchor, right: self.rightAnchor, paddingTop: 14, paddingLeft: 10, paddingRight: 20, height: 20)
        
        self.addSubview(noteLabel)
        noteLabel.anchor(top: userProfileImg.centerYAnchor, left: nameJobStack.leftAnchor, right: self.rightAnchor, paddingTop: 5, paddingRight: 20)
    }
    
    func shadowSetting() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 15
        self.layer.shadowOffset = CGSize(width: 3, height: 4)
        self.layer.shadowOpacity = 0.05
    }
}
