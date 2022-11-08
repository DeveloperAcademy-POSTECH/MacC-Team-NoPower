//
//  QuestCollectionViewCell.swift
//  BNomad
//
//  Created by 박성수 on 2022/11/08.
//

import UIKit

class QuestCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier: String = String(describing: QuestCollectionViewCell.self)
    
    let title: UILabel = {
        let title = UILabel()
        title.font = .preferredFont(forTextStyle: .headline, weight: .regular)
        title.text = "맛찬들 같이 가실 분!"
        title.numberOfLines = 1
        return title
    }()
    
    let participateButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        button.tintColor = CustomColor.nomadBlue
        return button
    }()
    
    let timeImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "timer")
        image.tintColor = CustomColor.nomadGray1
        return image
    }()
    
    let time: UILabel = {
        let time = UILabel()
        time.text = "12:00"
        time.textColor = CustomColor.nomadGray1
        return time
    }()
    
    let locationImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "signpost.right")
        image.tintColor = CustomColor.nomadGray1
        return image
    }()
    
    let location: UILabel = {
        let location = UILabel()
        location.text = "입구 앞"
        location.textColor = CustomColor.nomadGray1
        return location
    }()
    
    let currentCheckedPeople: String = "1"
    
    lazy var checkedPeople: UILabel = {
        let label = UILabel()
        label.text = "\(currentCheckedPeople) / 4"
        label.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        label.textColor = CustomColor.nomadGray1
        return label
    }()
    
    let checkedImage1: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.crop.circle.fill")
        image.anchor(width: 32, height: 32)
        image.tintColor = CustomColor.nomadGray1
        return image
    }()
    let checkedImage2: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.crop.circle.fill")
        image.anchor(width: 32, height: 32)
        return image
    }()
    let checkedImage3: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.crop.circle.fill")
        image.anchor(width: 32, height: 32)
        return image
    }()
    let checkedImage4: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.crop.circle.fill")
        image.anchor(width: 32, height: 32)
        return image
    }()
    
    lazy var checkedInPeople: [UIImageView] = [checkedImage1, checkedImage2, checkedImage3, checkedImage4]
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        for person in 1...Int(currentCheckedPeople)! + 1 {
            checkedInPeople.append(checkedInPeople[person])
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .systemBackground
        self.layer.cornerRadius = 12
        
        self.addSubview(participateButton)
        participateButton.anchor(top: self.topAnchor, right: self.rightAnchor, width: 32, height: 32)
        
        self.addSubview(title)
        title.anchor(top: self.topAnchor, left: self.leftAnchor, right: participateButton.leftAnchor, paddingTop: 16, paddingLeft: 12, paddingRight: 10)
        
        let upperStack = UIStackView(arrangedSubviews: [timeImage, time])
        upperStack.axis = .horizontal
        upperStack.spacing = 12
        upperStack.alignment = .leading
        let downStack = UIStackView(arrangedSubviews: [locationImage, location])
        downStack.axis = .horizontal
        downStack.spacing = 12
        downStack.alignment = .leading
        
        self.addSubview(upperStack)
        upperStack.anchor(top: title.bottomAnchor, left: self.leftAnchor, paddingTop: 25, paddingLeft: 14)
        self.addSubview(downStack)
        downStack.anchor(top: upperStack.bottomAnchor, left: self.leftAnchor, paddingTop: 7, paddingLeft: 14)
        
        let peopleStack = UIStackView(arrangedSubviews: checkedInPeople)
        peopleStack.axis = .horizontal
        peopleStack.spacing = -10
        
        self.addSubview(peopleStack)
        peopleStack.anchor(bottom: self.bottomAnchor, right: self.rightAnchor, paddingBottom: 13, paddingRight: 14)
        
        self.addSubview(checkedPeople)
        checkedPeople.anchor(bottom: self.bottomAnchor, right: peopleStack.leftAnchor, paddingBottom: 15, paddingRight: 11)
    }
    
}
