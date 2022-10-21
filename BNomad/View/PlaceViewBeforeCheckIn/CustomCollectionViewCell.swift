//
//  CollectionViewCell.swift
//  BNomad
//
//  Created by 박진웅 on 2022/10/18.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    static let identifier = "CustomCollectionViewCell"

    // MARK: - Properties
    lazy var cell: UIButton = {
        let rectangle = UIButton()
        rectangle.frame = CGRect(x: 0, y: 0, width: 356, height: 86)
        rectangle.layer.cornerRadius = 12
        rectangle.translatesAutoresizingMaskIntoConstraints = false
        rectangle.backgroundColor = .white
        rectangle.addSubview(name)
        rectangle.addSubview(numberOfCheckIn)
        rectangle.addSubview(distance)
        rectangle.addSubview(averageTime)
        rectangle.addSubview(arrow)
        name.anchor(top: rectangle.topAnchor, left: rectangle.leftAnchor, paddingTop: 23, paddingLeft: 9)
        numberOfCheckIn.anchor(top: rectangle.topAnchor, right: rectangle.rightAnchor, paddingTop: 26, paddingRight: 50)
        distance.anchor(left: rectangle.leftAnchor, bottom: rectangle.bottomAnchor, paddingLeft: 11, paddingBottom: 8)
        averageTime.anchor(bottom: rectangle.bottomAnchor, right: rectangle.rightAnchor, paddingBottom: 8, paddingRight: 48)
        arrow.centerYAnchor.constraint(equalTo: rectangle.centerYAnchor).isActive = true
        arrow.rightAnchor.constraint(equalTo: rectangle.rightAnchor, constant: -12.45).isActive = true
        return rectangle
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
//        let config = UIImage.SymbolConfiguration(pointSize: 16.95)
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

    func setUpCell() {
        contentView.addSubview(cell)
        cell.anchor(width: 356, height: 86)
        cell.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
}