//
//  NoMeetUpCell.swift
//  BNomad
//
//  Created by Eunbee Kang on 2022/11/24.
//

import UIKit

class NoMeetUpCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier: String = String(describing: NoMeetUpCell.self)
    
    private let noMeetUpLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 밋업이 없어요."
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = CustomColor.nomadGray1
        
        return label
    }()
    
    private let makeNewMeetUpLabel: UILabel = {
        let label = UILabel()
        label.text = "새로운 밋업을 만들어보세요."
        label.font = .preferredFont(forTextStyle: .footnote, weight: .semibold)
        label.textColor = CustomColor.nomadGray1
        
        return label
    }()
    
    private lazy var labelStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [noMeetUpLabel, makeNewMeetUpLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        
        return stackView
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configUI() {
        self.backgroundColor = CustomColor.nomad2White
        self.layer.cornerRadius = 12
        
        self.addSubview(labelStack)
        labelStack.center(inView: self)
    }
}
