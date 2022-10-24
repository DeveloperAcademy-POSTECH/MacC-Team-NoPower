//
//  CollectionViewCell.swift
//  BNomad
//
//  Created by 박진웅 on 2022/10/18.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    static let identifier = "CustomCollectionViewCell"

    // MARK: - Properties
    
    lazy var cell: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.addSubview(name)
        view.addSubview(numberOfCheckIn)
        view.addSubview(distance)
        view.addSubview(averageTime)
        view.addSubview(arrow)
        name.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 23, paddingLeft: 9)
        numberOfCheckIn.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 26, paddingRight: 50)
        distance.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 11, paddingBottom: 8)
        averageTime.anchor(bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: 8, paddingRight: 48)
        arrow.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        arrow.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12.45).isActive = true
        return view
    }()
    
    var name: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        title.textColor = .black
        title.font = .preferredFont(forTextStyle: .title2, weight: .bold)
        title.text = "투썸 플레이스"
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var numberOfCheckIn: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        title.textColor = .black
        title.font = .preferredFont(forTextStyle: .body, weight: .regular)
        title.text = "3명 체크인"
        title.font = UIFont(name: "SFProText-Regular", size: 17)
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var distance: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        title.textColor = CustomColor.nomadGray2
        title.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        title.text = "1.5km"
        title.font = UIFont(name: "SFProText-Regular", size: 15)
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var averageTime: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        title.textColor = CustomColor.nomadGray2
        title.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        title.text = "평균 5시간 근무"
        title.font = UIFont(name: "SFProText-Regular", size: 13)
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    let arrow: UIImageView = {
        let image = UIImage(systemName: "chevron.right")?.withTintColor(CustomColor.nomadBlue ?? .blue, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - LifeCycle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
    }

    // MARK: - Helpers
    
    func setUpCell() {
        contentView.addSubview(cell)
        cell.anchor(top: self.topAnchor, width: 356, height: 86)
        cell.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
}
