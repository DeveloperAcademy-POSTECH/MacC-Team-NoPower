//
//  ProfileGraphCell.swift
//  BNomad
//
//  Created by Beone on 2022/10/19.
//

import UIKit


class ProfileGraphCell: UICollectionViewCell {
    
    // MARK: - Properties
    lazy var viewModel = CombineViewModel.shared

    var checkInHistory: [CheckIn]?
    
    static let identifier = "ProfileGraphCell"
    static var addedWeek: Int = 0 {
        didSet {
            profileGraphCollectionView.reloadData()
        }
    }
    
    private let timeLabel: [UILabel] = {
        var label:[UILabel] = []
        
        for index in 0...3 {
            let time = UILabel()
            time.text = String(9 + index*3) //FIXME: 그래프 간격 어떻게 할건지? 현재는 데이터 로직 기준
            time.textColor = .gray
            time.font = .preferredFont(forTextStyle: .caption2, weight: .regular)
            time.translatesAutoresizingMaskIntoConstraints = false
            label.append(time)
        }
        return label
    }()
    
    static var dayLabel: [UILabel] = {
        var label: [UILabel] = []
        
        for index in 0..<7 {
            let day = UILabel()
            day.text = Contents.dateLabelMaker()[index][3]
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d"
            if Contents.dateLabelMaker()[index][2] == formatter.string(from: Date()) {
                day.textColor = CustomColor.nomadGreen
            }
            
            day.font = .preferredFont(forTextStyle: .caption2, weight: .regular)
            day.translatesAutoresizingMaskIntoConstraints = false
            label.append(day)
        }
        return label
    }()
    
    private static let profileGraphCollectionView:  UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.register(ProfileGraphCollectionCell.self, forCellWithReuseIdentifier: ProfileGraphCollectionCell.identifier)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    // MARK: - LifeCycle
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            ProfileGraphCell.profileGraphCollectionView.dataSource = self
            ProfileGraphCell.profileGraphCollectionView.delegate = self
            
            render()
            self.backgroundColor = .white
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(corder:) has not been implemented")
        }
    
    // MARK: - Helpers
    
    func render() {
        
        let timeStack = UIStackView(arrangedSubviews: timeLabel)
        timeStack.axis = .vertical
        timeStack.spacing = 35
        timeStack.distribution = .fillEqually
        timeStack.translatesAutoresizingMaskIntoConstraints = false
        
        let dayStack = UIStackView(arrangedSubviews: ProfileGraphCell.dayLabel)
        dayStack.axis = .horizontal
        dayStack.spacing = (CGFloat(contentView.frame.width)-55-24*7)/6
        dayStack.distribution = .fillEqually
        dayStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(timeStack)
        timeStack.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 10, paddingLeft: 10)
        
        contentView.addSubview(dayStack)
        dayStack.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 166, paddingLeft: 45)

        contentView.addSubview(ProfileGraphCell.profileGraphCollectionView)
        ProfileGraphCell.profileGraphCollectionView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 10, paddingLeft: 42, width: contentView.frame.width, height: 154)
        
    }
    
    static func editWeek(edit: Int) { //TODO: 로직 그래프컬렉션셀 안으로 이동 리펙터링 필요
        addedWeek = addedWeek + edit
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        for index in Contents.dateLabelMaker().indices {
            if Contents.dateLabelMaker()[index][2] == formatter.string(from:Date()) && addedWeek == 0 {
                dayLabel[index].textColor = CustomColor.nomadGreen
            } else {
                dayLabel[index].textColor = .black
            }
        }
        
    }
    
}

// MARK: - UICollectionViewDataSource

extension ProfileGraphCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
}

// MARK: - UICollectionViewDelegate

extension ProfileGraphCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileGraphCollectionCell.identifier , for: indexPath) as? ProfileGraphCollectionCell else {
            return UICollectionViewCell()
        }
        
        let weekCalculator = ProfileGraphCell.addedWeek * 7
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let dayCalculator = (86400 * (1-Contents.todayOfTheWeek + weekCalculator + indexPath.item))
        let cellDate = formatter.string(from: Date(timeIntervalSinceNow: TimeInterval(dayCalculator)))
        
        cell.cellDate = cellDate
        cell.checkInHistory = checkInHistory
        cell.backgroundColor = .white
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileGraphCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
            return CGSize(width: 27, height: 154)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return (CGFloat(contentView.frame.width)-55-27*7)/6
        
    }
}
