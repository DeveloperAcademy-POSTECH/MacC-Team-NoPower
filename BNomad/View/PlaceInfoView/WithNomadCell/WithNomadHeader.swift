//
//  WithNomadHeader.swift
//  BNomad
//
//  Created by 유재훈 on 2022/11/11.
//

import UIKit

class WithNomadHeader: UICollectionViewCell {
    
    static let identifier = "WithNomadHeader"
    
    var numberOfUsers: Int = 0 {
        didSet {
            label.text = "함께 일하고 있는 \(numberOfUsers)명의 노마더"
            let fullText = label.text ?? ""
            let attribtuedString = NSMutableAttributedString(string: fullText)
            let range = (fullText as NSString).range(of: "\(numberOfUsers)명")
            attribtuedString.addAttribute(.foregroundColor, value: CustomColor.nomadBlue as Any, range: range)
            label.attributedText = attribtuedString
        }
    }
    

    // MARK: - Properties
    
    lazy var label: UILabel = {
        let label = UILabel()
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
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(label)
        backgroundColor = .white
        setui()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func setui() {
        label.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 0, paddingLeft: 20)
    }
}

