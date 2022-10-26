//
//  CheckedProfileListViewCell.swift
//  BNomad
//
//  Created by yeekim on 2022/10/19.
//

import UIKit

class CheckedProfileListViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    // var user: User
    var userUid: String? {
        didSet {
            guard let userUid = userUid else { return }
            FirebaseManager.shared.fetchUser(id: userUid) { user in
                self.user = user
            }
        }
    }
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            usernameLabel.text = user.nickname
            occupationLabel.text = user.occupation
            noteLabel.text = user.introduction
        }
    }
    
    static let identifier = "CheckedProfileListViewCell"
    
    private let userProfileImg: UIImageView = {
        let userProfileImg = UIImageView()
        userProfileImg.image = UIImage(named: "othersProfile")
        userProfileImg.translatesAutoresizingMaskIntoConstraints = false
        return userProfileImg
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let occupationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body, weight: .regular)
        label.textColor = CustomColor.nomadGray1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
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
    
    func render() {
        // 프로필 이미지
        self.addSubview(userProfileImg)
        userProfileImg.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 17, paddingLeft: 24)
        
        // 사용자 이름
        self.addSubview(usernameLabel)
        usernameLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 19, paddingLeft: 102)
        
        // 직업
        self.addSubview(occupationLabel)
        occupationLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 19, paddingLeft: 178)
        
        // 상태 메세지
        self.addSubview(noteLabel)
        noteLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 44, paddingLeft: 102)
    }
}
