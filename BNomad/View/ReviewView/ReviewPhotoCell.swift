//
//  ReviewPhotoCell.swift
//  BNomad
//
//  Created by 박진웅 on 2022/11/10.
//

import UIKit

class AddPhotoCell: UICollectionViewCell {

    static let identifier = "AddPhotoCell"
    
    lazy var cell: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor(hex: "F5F5F5")
        view.addSubview(addPhotoButton)
        addPhotoButton.centerX(inView: view)
        addPhotoButton.centerY(inView: view)
        return view
    }()
    
    private let addPhotoButton: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 15)
        let image = UIImage(systemName: "plus", withConfiguration: config)?.withTintColor(UIColor(hex: "3C3C43")?.withAlphaComponent(0.6) ?? .black, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
    }

    func setUpCell() {
        contentView.addSubview(cell)
        cell.anchor(width: (UIScreen.main.bounds.width-64)/3, height: (UIScreen.main.bounds.width-64)/3)
    }

}

class RemovePhotoCell: UICollectionViewCell {

    static let identifier = "RemovePhotoCell"
    
    lazy var cell: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor(hex: "F5F5F5")
        view.addSubview(RemovePhotoCell.photo)
        RemovePhotoCell.photo.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 0, paddingLeft: 0)
        RemovePhotoCell.photo.centerX(inView: view)
        RemovePhotoCell.photo.centerY(inView: view)
        view.addSubview(removeButton)
        removeButton.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingRight: 0, width: 25, height: 25)
        return view
    }()
    
    static var photo: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 15)
        let image = UIImage(named: "AppIcon")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    private lazy var removeButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 14)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.layer.backgroundColor = UIColor.black.withAlphaComponent(0.7).cgColor
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(removePhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func removePhoto() {
        print("SUCCEEEDDD")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
    }

    func setUpCell() {
        contentView.addSubview(cell)
        cell.anchor(width: (UIScreen.main.bounds.width-64)/3, height: (UIScreen.main.bounds.width-64)/3)
    }

}
