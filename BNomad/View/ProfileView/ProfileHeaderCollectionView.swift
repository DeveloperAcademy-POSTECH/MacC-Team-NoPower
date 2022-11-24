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
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .headline, weight: .semibold)
        return label
    }()
    
    private let viewAllButton: UIButton = {
       let button = UIButton()
        button.setTitle("전체보기", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
        button.setTitleColor(.gray, for: .normal)
        return button
    }()
    
    private let plusWeek: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = CustomColor.nomadBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        button.setTitleColor(CustomColor.nomadSkyblue, for: .normal)
        return button
    }()
    
    private let minusWeek: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = CustomColor.nomadBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        button.setTitleColor(CustomColor.nomadSkyblue, for: .normal)
        return button
    }()
    
    private let profileGraphCellHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "주간 통계"
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .headline, weight: .semibold)
        return label
    }()
    
    var profileGraphCellWeekLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        return label
    }()
    
    //MARK: -LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        ProfileHeaderCollectionView.profileGraphCellHeaderMaker(label: profileGraphCellWeekLabel, weekAdded: -ProfileHeaderCollectionView.weekAddedMemory)
        
        plusWeek.addTarget(self, action: #selector(plusTapButton), for: .touchUpInside)
        minusWeek.addTarget(self, action: #selector(minusTapButton), for: .touchUpInside)
        viewAllButton.addTarget(self, action: #selector(viewAllTap), for: .touchUpInside)
        
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
        label.textColor = .black
        
    }
    
    func setVisitCardHeader() {
        minusWeek.removeFromSuperview()
        plusWeek.removeFromSuperview()
        profileGraphCellWeekLabel.removeFromSuperview()
        profileGraphCellHeaderLabel.removeFromSuperview()
        
        addSubview(visitCardCellHeaderLabel)
        visitCardCellHeaderLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 28, paddingLeft: 20)
        
        addSubview(viewAllButton)
        viewAllButton.anchor(top:self.topAnchor, right: self.rightAnchor, paddingTop: 28, paddingRight: 20)
    }
    
    func setGraphHeader() {
        visitCardCellHeaderLabel.removeFromSuperview()
        viewAllButton.removeFromSuperview()
        
        addSubview(profileGraphCellHeaderLabel)
        profileGraphCellHeaderLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 28, paddingLeft: 20)
        
        
        addSubview(profileGraphCellWeekLabel)
        profileGraphCellWeekLabel.centerX(inView: self)
        profileGraphCellWeekLabel.anchor(top: self.topAnchor, paddingTop: 64)
        
        addSubview(minusWeek)
        minusWeek.anchor(left: self.leftAnchor, paddingLeft: 90)
        minusWeek.centerY(inView: profileGraphCellWeekLabel)
        
        addSubview(plusWeek)
        plusWeek.anchor(right: self.rightAnchor, paddingRight: 90)
        plusWeek.centerY(inView: profileGraphCellWeekLabel)
    }
    
    @objc func plusTapButton() {
        ProfileHeaderCollectionView.profileGraphCellHeaderMaker(label: profileGraphCellWeekLabel, weekAdded: 1)
        delegate?.plusTap()
    }
    
    @objc func minusTapButton() {
        ProfileHeaderCollectionView.profileGraphCellHeaderMaker(label: profileGraphCellWeekLabel, weekAdded: -1)

        delegate?.minusTap()
    }
    
    @objc func viewAllTap() {
        delegate?.viewAllTap()
    }
}

//MARK: -hitbox extension

extension UIButton {

  open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    let margin: CGFloat = 10
    let hitArea = self.bounds.insetBy(dx: -margin, dy: -margin)
    return hitArea.contains(point)
  }
}


//MARK: -graphHeaderButton Protocol

protocol PlusMinusProtocol {
    func plusTap()
    func minusTap()
    func viewAllTap()
}

