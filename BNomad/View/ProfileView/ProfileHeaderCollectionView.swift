//
//  VisitCardHeaderCollectionView.swift
//  BNomad
//
//  Created by Beone on 2022/11/15.
//

import UIKit

class ProfileHeaderCollectionView: UICollectionReusableView {
    static let identifier = "ProfileHeaderCollectionView"
    
    var delegate: PlusMinusProtocol?
    
    // MARK: - Properties

    static var weekAddedMemory: Int = 0
    
    private let visitCardCellHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 방문한 장소"
        label.font = .preferredFont(forTextStyle: .headline, weight: .semibold)
        return label
    }()
    
    private let plusWeek: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        button.setTitleColor(CustomColor.nomadSkyblue, for: .normal)
        return button
    }()
    
    private let minusWeek: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        button.setTitleColor(CustomColor.nomadSkyblue, for: .normal)
        return button
    }()
    
    var profileGraphCellHeaderLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        return label
    }()
    
    //MARK: -LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        ProfileHeaderCollectionView.profileGraphCellHeaderMaker(label: profileGraphCellHeaderLabel, weekAdded: -ProfileHeaderCollectionView.weekAddedMemory)
        
        plusWeek.addTarget(self, action: #selector(plusTapButton), for: .touchUpInside)
        minusWeek.addTarget(self, action: #selector(minusTapButton), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -Actions

    static func profileGraphCellHeaderMaker(label: UILabel, weekAdded: Int) {
        
        weekAddedMemory += weekAdded
        print("DBG0:", weekAddedMemory)
        let weekCalculator = weekAddedMemory * 7
        let formatter = DateFormatter()
        formatter.dateFormat = "M.d"
        
        let sundayCalculator = (86400 * (1-Contents.todayOfTheWeek + weekCalculator))
        let saturdayCalculator = (86400 * (1-Contents.todayOfTheWeek+6 + weekCalculator))
        
        let sundayDate = formatter.string(from: Date(timeIntervalSinceNow: TimeInterval(sundayCalculator)))
        let saturdayDate = formatter.string(from: Date(timeIntervalSinceNow: TimeInterval(saturdayCalculator)))

        label.text = sundayDate+" ~ "+saturdayDate
        
    }
    
    func setVisitCardHeader() {
        minusWeek.removeFromSuperview()
        plusWeek.removeFromSuperview()
        profileGraphCellHeaderLabel.removeFromSuperview()
        
        addSubview(visitCardCellHeaderLabel)
        visitCardCellHeaderLabel.anchor(left: self.leftAnchor, paddingLeft: 20)
        visitCardCellHeaderLabel.centerY(inView: self)
    }
    
    func setGraphHeader() {
        visitCardCellHeaderLabel.removeFromSuperview()
        
        addSubview(profileGraphCellHeaderLabel)
        profileGraphCellHeaderLabel.centerX(inView: self)
        profileGraphCellHeaderLabel.centerY(inView: self)
        
        addSubview(minusWeek)
        minusWeek.anchor(left: self.leftAnchor, paddingLeft: 20)
        minusWeek.centerY(inView: self)
        
        addSubview(plusWeek)
        plusWeek.anchor(right: self.rightAnchor, paddingRight: 20)
        plusWeek.centerY(inView: self)
    }
    
    @objc func plusTapButton() {
        ProfileHeaderCollectionView.profileGraphCellHeaderMaker(label: profileGraphCellHeaderLabel, weekAdded: 1)
        delegate?.plusTap()
    }
    
    @objc func minusTapButton() {
        ProfileHeaderCollectionView.profileGraphCellHeaderMaker(label: profileGraphCellHeaderLabel, weekAdded: -1)

        delegate?.minusTap()
    }
}

//MARK: -graphHeaderButton Protocol

protocol PlusMinusProtocol {
    func plusTap()
    func minusTap()
}
