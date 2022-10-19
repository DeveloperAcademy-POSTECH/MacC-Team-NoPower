//
//  CustomCollectionViewCell.swift
//  BottomSheet
//
//  Created by 박진웅 on 2022/10/18.
//  Copyright © 2022 Zafar. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    static let identifier = "CustomCollectionViewCell"

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setUpCell()
//    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
    }

    func setUpCell() {
        contentView.addSubview(cell)
        cell.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        cell.widthAnchor.constraint(equalToConstant: 356).isActive = true
        cell.heightAnchor.constraint(equalToConstant: 86).isActive = true
    }
    
    lazy var cell: UIButton = {
        let rectangle = UIButton()
        rectangle.frame = CGRect(x: 0, y: 0, width: 356, height: 86)
        rectangle.layer.cornerRadius = 12
        rectangle.translatesAutoresizingMaskIntoConstraints = false
        rectangle.backgroundColor = .white
        rectangle.addSubview(name)
        name.topAnchor.constraint(equalTo: rectangle.topAnchor, constant: 23).isActive = true
        name.leftAnchor.constraint(equalTo: rectangle.leftAnchor, constant: 9).isActive = true
        rectangle.addSubview(numberOfCheckIn)
        numberOfCheckIn.topAnchor.constraint(equalTo: rectangle.topAnchor, constant: 26).isActive = true
        numberOfCheckIn.rightAnchor.constraint(equalTo: rectangle.rightAnchor, constant: -50).isActive = true
        rectangle.addSubview(distance)
        distance.bottomAnchor.constraint(equalTo: rectangle.bottomAnchor, constant: -8).isActive = true
        distance.leftAnchor.constraint(equalTo: rectangle.leftAnchor, constant: 11).isActive = true
        rectangle.addSubview(averageTime)
        averageTime.bottomAnchor.constraint(equalTo: rectangle.bottomAnchor, constant: -8).isActive = true
        averageTime.rightAnchor.constraint(equalTo: rectangle.rightAnchor, constant: -48).isActive = true
        rectangle.addSubview(arrow)
        arrow.centerYAnchor.constraint(equalTo: rectangle.centerYAnchor).isActive = true
        arrow.rightAnchor.constraint(equalTo: rectangle.rightAnchor, constant: -12.45).isActive = true
        return rectangle
    }()
    
    var name: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        title.textColor = .black
//        title.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
        title.text = "투썸 플레이스"
        title.font = UIFont(name: "SFProDisplay-Bold", size: 22)
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var numberOfCheckIn: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        title.textColor = .black
//        title.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
        title.text = "3명 체크인"
        title.font = UIFont(name: "SFProText-Regular", size: 17)
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var distance: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        title.textColor = UIColor(red: 0.557, green: 0.557, blue: 0.576, alpha: 1)
//        title.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
        title.text = "1.5km"
        title.font = UIFont(name: "SFProText-Regular", size: 15)
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var averageTime: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        title.textColor = UIColor(red: 0.557, green: 0.557, blue: 0.576, alpha: 1)
//        title.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
        title.text = "평균 5시간 근무"
        title.font = UIFont(name: "SFProText-Regular", size: 13)
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    let arrow: UIImageView = {
//        let config = UIImage.SymbolConfiguration(pointSize: 16.95)
        let image = UIImage(systemName: "chevron.right")?.withTintColor(.blue, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
}
