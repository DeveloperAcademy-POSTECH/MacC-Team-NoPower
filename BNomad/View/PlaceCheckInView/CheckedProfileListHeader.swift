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
                label.asFont(targetString: "\(number)명", font: .preferredFont(forTextStyle: .headline, weight: .bold))
            }
        }
    }

    // MARK: - Properties
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline, weight: .bold)
        label.textColor = CustomColor.nomadBlack
        return label
    }()
    
    private let listIcon: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "list.bullet"), for:.normal)
        btn.tintColor = CustomColor.nomadGray1
        return btn
    }()
    
    private let gridIcon: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "circle.grid.3x3.fill"), for:.normal)
        btn.tintColor = CustomColor.nomadGray2
        return btn
    }()

    lazy var menuView: UIView = {
        let menuView = UIView()
        menuView.layer.borderWidth = 1
        menuView.layer.cornerRadius = 10
        menuView.layer.borderColor = CustomColor.nomadGray2?.cgColor
        menuView.backgroundColor = .white
        menuView.addSubview(listIcon)
        menuView.addSubview(gridIcon)
        listIcon.anchor(left: menuView.leftAnchor, paddingLeft: 8, height: 15)
        listIcon.centerY(inView: menuView)
        gridIcon.anchor(right: menuView.rightAnchor, paddingRight: 8, height: 15)
        gridIcon.centerY(inView: menuView)
        
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
        label.anchor(left: contentView.leftAnchor, paddingLeft: 17)
        label.centerY(inView: contentView)
        
        addSubview(menuView)
        menuView.anchor(right: self.rightAnchor, paddingRight: 17, width: 64, height: 27)
        menuView.centerY(inView: self)
    }
}
