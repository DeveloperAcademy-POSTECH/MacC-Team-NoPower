//
//  QuestCollectionViewCell.swift
//  BNomad
//
//  Created by 박성수 on 2022/11/08.
//

import UIKit
import Kingfisher

class QuestCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier: String = String(describing: QuestCollectionViewCell.self)
    
    let viewModel = CombineViewModel.shared
    
    var meetUp: MeetUp? {
        didSet {
            guard let meetUp = meetUp else { return }
            title.text = meetUp.title
            time.text = meetUp.time.toTimeString()
            location.text = meetUp.meetUpPlaceName
            checkedPeople.text = "\(meetUp.currentPeopleUids?.count ?? 0) / \(meetUp.maxPeopleNum)"
            
            checkedInPeople = meetUp.currentPeopleUids?.map { userUid in
                let image = UIImageView()
                image.anchor(width: 32, height: 32)
                image.tintColor = CustomColor.nomadGray1
                FirebaseManager.shared.fetchUser(id: userUid) { user in
                    guard let profileImageUrl = user.profileImageUrl else { return }
                    image.kf.setImage(with: URL(string: profileImageUrl))
                }
                return image
            }
            
            guard let userUid = viewModel.user?.userUid else { return }
            isParticipated = meetUp.currentPeopleUids?.contains(userUid)
        }
    }
    
    var checkedInPeople: [UIImageView]? {
        didSet {
            configureCheckInPeopleUI()
        }
    }
    
    var isParticipated: Bool? {
        didSet {
            configCheckMark()
        }
    }
    
    var title: UILabel = {
        let title = UILabel()
        title.font = .preferredFont(forTextStyle: .headline)
        title.numberOfLines = 1
        return title
    }()
    
    let checkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.tintColor = CustomColor.nomadBlue
        
        return imageView
    }()
    
    let unCheckView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = CustomColor.nomadGray2?.cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    
    let timeImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "timer")
        image.tintColor = CustomColor.nomadGray1
        return image
    }()
    
    var time: UILabel = {
        let time = UILabel()
        time.textColor = CustomColor.nomadGray1
        return time
    }()
    
    let locationImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "signpost.right")
        image.tintColor = CustomColor.nomadGray1
        return image
    }()
    
    var location: UILabel = {
        let location = UILabel()
        location.textColor = CustomColor.nomadGray1
        return location
    }()
    
    var checkedPeople: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        label.textColor = CustomColor.nomadGray1
        return label
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        shadowSetting()
        configureUI()
        configCheckMark()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    
    // MARK: - Helpers
    
    func shadowSetting() {
        backgroundColor = .systemBackground
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 15
        self.layer.shadowOffset = CGSize(width: 3, height: 4)
        self.layer.shadowOpacity = 0.05
    }
    
    func configCheckMark() {
        if isParticipated == true {
            checkImage.isHidden = false
        } else {
            checkImage.isHidden = true
        }
    }
    
    func configureUI() {
        self.addSubview(title)
        title.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 16, paddingLeft: 12)
        
        let timeStack = UIStackView(arrangedSubviews: [timeImage, time])
        timeStack.axis = .horizontal
        timeStack.spacing = 12
        timeStack.alignment = .leading
        let locationStack = UIStackView(arrangedSubviews: [locationImage, location])
        locationStack.axis = .horizontal
        locationStack.spacing = 12
        locationStack.alignment = .leading
        
        self.addSubview(timeStack)
        timeStack.anchor(top: title.bottomAnchor, left: self.leftAnchor, paddingTop: 25, paddingLeft: 14)
        self.addSubview(locationStack)
        locationStack.anchor(top: timeStack.bottomAnchor, left: self.leftAnchor, paddingTop: 7, paddingLeft: 14)
        
        let checkSize: CGFloat = 32

        self.addSubview(unCheckView)
        unCheckView.layer.cornerRadius = checkSize / 2
        unCheckView.anchor(top: self.topAnchor, right: self.rightAnchor, paddingTop: 10, paddingRight: 10, width: checkSize, height: checkSize)
        
        self.addSubview(checkImage)
        checkImage.anchor(top: self.topAnchor, right: self.rightAnchor, paddingTop: 10, paddingRight: 10, width: checkSize, height: checkSize)
    }
    
    func configureCheckInPeopleUI() {
        guard let checkedInPeople = checkedInPeople else { return }
        
        let peopleStack = UIStackView(arrangedSubviews: checkedInPeople)
        peopleStack.axis = .horizontal
        peopleStack.spacing = -10
        
        self.addSubview(peopleStack)
        peopleStack.anchor(bottom: self.bottomAnchor, right: self.rightAnchor, paddingBottom: 13, paddingRight: 14)
        
        self.addSubview(checkedPeople)
        checkedPeople.anchor(bottom: self.bottomAnchor, right: peopleStack.leftAnchor, paddingBottom: 15, paddingRight: 11)
    }
}
