//
//  CheckedProfileListReusableView.swift
//  BNomad
//
//  Created by yeekim on 2022/10/19.
//

import UIKit

class CheckedProfileListHeader: UICollectionViewCell {
    
    static let identifier = "CheckedProfileListHeader"
    
    var numberOfUsers: Int? {
        didSet {
            if let number = numberOfUsers {
                label.text = "함께 일하고 있는 \(number)명의 노마더"
            }
        }
    }

    // MARK: - Properties
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        label.textColor = CustomColor.nomadBlack
        return label
    }()
    
    private let listIcon: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "list.bullet"), for:.normal)
        btn.tintColor = .systemGray
        return btn
    }()
    
    private let gridIcon: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "circle.grid.3x3.fill"), for:.normal)
        btn.tintColor = .systemGray
        return btn
    }()

    lazy var menuView: UIView = {
        let menuView = UIView()
        menuView.frame = CGRect(x:0, y:0, width: 64, height: 35)
        menuView.layer.borderWidth = 1
        menuView.layer.cornerRadius = 12
        menuView.layer.borderColor = CustomColor.nomadGray2?.cgColor
        menuView.backgroundColor = .white
        menuView.addSubview(listIcon)
        menuView.addSubview(gridIcon)
        listIcon.anchor(top: menuView.topAnchor ,left: menuView.leftAnchor, bottom: menuView.bottomAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 8)
        gridIcon.anchor(top: menuView.topAnchor, bottom: menuView.bottomAnchor, right: menuView.rightAnchor, paddingTop: 4, paddingBottom: 8, paddingRight: 8)
        return menuView
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func render() {
        addSubview(label)
        addSubview(menuView)
        label.anchor(left: contentView.leftAnchor, paddingLeft: 17)
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        menuView.anchor(left: contentView.leftAnchor, paddingLeft: 309, width: 64, height: 35)
        menuView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
