//
//  ProfileViewCell.swift
//  BNomad
//
//  Created by Beone on 2022/10/18.
//

import UIKit

protocol MovePage {
    func moveToEditingPage()
}

// TODO: 하드 코딩된 부분 제거 
class SelfUserInfoCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            self.nameLabel.text = user?.nickname
            self.jobLabel.text = user?.occupation
            self.statusLabel.text = user?.introduction
        }
    }
    static let identifier = "SelfUserInfoCell"
    
    var delegate: MovePage?
        
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = DummyData.user1.nickname
        label.font = .preferredFont(forTextStyle: .title1, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    lazy var editingButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("프로필 수정", for: .normal)
        button.tintColor = CustomColor.nomadGray1
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(moveToEditing), for: .touchUpInside)
        return button
    }()
    
    private let jobLabel: UILabel = {
        let label = UILabel()
        label.text = "iOS Developer"
        label.textColor = .gray
        label.font = .preferredFont(forTextStyle: .body, weight: .semibold)
        return label
    }()
    
    private let dividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.nomadGray1
        view.layer.masksToBounds = false

        return view
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0 //TODO: 행간 늘이기
        label.text = "안녕하세요 반가워요 윌로우에요 ios 개발 하고있어요, 디자인에도 관심이 많아서 대화 나누기 좋아해요"
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .footnote, weight: .regular)

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
    
    // MARK: - Actions
    
    @objc func moveToEditing() {
        delegate?.moveToEditingPage()
    }
    
    // MARK: - Helpers
    
    func render() {

        contentView.addSubview(nameLabel)
        nameLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 40, paddingLeft: 20)
        
        contentView.addSubview(editingButton)
        editingButton.anchor(top: contentView.topAnchor, right: contentView.rightAnchor, paddingTop: 12, paddingRight: 12, width: 55, height: 13)
        
        contentView.addSubview(jobLabel)
        jobLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 75, paddingLeft: 20, paddingRight: 20)
        
        contentView.addSubview(dividerLine)
        dividerLine.anchor(top: jobLabel.bottomAnchor, left: contentView.leftAnchor, bottom: jobLabel.bottomAnchor, right: contentView.rightAnchor, paddingTop: 33, paddingLeft: 10, paddingBottom: -18, paddingRight: 10, width: 340, height: 1)
        
        contentView.addSubview(statusLabel)
        statusLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 125, paddingLeft: 20, paddingRight: 20)
        
    }

}

