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
                numberOfPeople.text = "\(number)명"
            }
        }
    }

    // MARK: - Properties
    
    private let firstLabel: UILabel = {
        let label = UILabel()
        label.text = "함께 일하고 있는 "
        label.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        label.textColor = CustomColor.nomadBlack
        return label
    }()
    
    lazy var numberOfPeople: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        label.textColor = CustomColor.nomadBlue
        return label
    }()
    
    private let lastLabel: UILabel = {
        let label = UILabel()
        label.text = "의 노마드"
        label.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        label.textColor = CustomColor.nomadBlack
        
        return label
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
        let stack = UIStackView(arrangedSubviews: [firstLabel, numberOfPeople, lastLabel])
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .fill
        
        self.addSubview(stack)
        stack.anchor(left: self.leftAnchor, paddingLeft: 20)
        stack.centerY(inView: self)
    }
    
}
