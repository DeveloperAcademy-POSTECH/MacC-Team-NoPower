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
            withNomadCountLabel.text = "함께 일하고 있는 \(numberOfUsers)명의 노마더"
            let fullText = withNomadCountLabel.text ?? ""
            let attribtuedString = NSMutableAttributedString(string: fullText)
            let range = (fullText as NSString).range(of: "\(numberOfUsers)명")
            attribtuedString.addAttribute(.foregroundColor, value: CustomColor.nomadBlue as Any, range: range)
            withNomadCountLabel.attributedText = attribtuedString
        }
    }
    

    // MARK: - Properties
    
    lazy var withNomadCountLabel: UILabel = {
        let withNomadCountLabel = UILabel()
        withNomadCountLabel.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        withNomadCountLabel.textColor = CustomColor.nomadBlack

        return withNomadCountLabel
    }()
    
    lazy var numberOfPeople: UILabel = {
        let numberOfPeople = UILabel()
        numberOfPeople.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        numberOfPeople.textColor = CustomColor.nomadBlue
        
        return numberOfPeople
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(withNomadCountLabel)
        setUi()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func setUi() {
        withNomadCountLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 0, paddingLeft: 20)
    }
}

