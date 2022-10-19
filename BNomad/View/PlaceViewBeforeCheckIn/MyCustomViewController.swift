//
//  MyCustomViewController.swift
//  BottomSheet
//
//  Created by Zafar on 8/13/20.
//  Copyright © 2020 Zafar. All rights reserved.
//

import UIKit
import MapKit

class MyCustomViewController: UIViewController {
    
//    let rectangle = UIView()
    // MARK: - Properties
    
    var rectangle: UIView = {
        let rectangle = UIView()
        rectangle.frame = CGRect(x: 0, y: 0, width: 80, height: 5)
        rectangle.layer.cornerRadius = 3
        rectangle.translatesAutoresizingMaskIntoConstraints = false
        rectangle.backgroundColor = .systemGray2
        return rectangle
    }()
    
    var numberOfPlaces: UILabel = {
        let number = UILabel()
        number.backgroundColor = .clear
        number.textColor = .black
        number.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
        number.text = "업무 공간 9개"
        number.font = UIFont(name: "SFProText-Semibold", size: 15)
        number.textAlignment = .center
        number.translatesAutoresizingMaskIntoConstraints = false
        return number
    }()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.backgroundColor = UIColor(red: 0.967, green: 0.967, blue: 0.967, alpha: 1).cgColor
        self.view.layer.cornerRadius = 20
        self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.view.layer.shadowColor = UIColor.black.cgColor
        self.view.layer.shadowOffset = .init(width: 0, height: -2)
        self.view.layer.shadowRadius = 20
        self.view.layer.shadowOpacity = 0.5
        
        self.view.addSubview(rectangle)
        self.view.addSubview(numberOfPlaces)
        self.view.addSubview(collectionView)
    
        rectangle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
        rectangle.widthAnchor.constraint(equalToConstant: 80).isActive = true
        rectangle.heightAnchor.constraint(equalToConstant: 5).isActive = true
        rectangle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        numberOfPlaces.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        numberOfPlaces.topAnchor.constraint(equalTo: self.rectangle.topAnchor, constant: 18).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.numberOfPlaces.bottomAnchor, constant: 33).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
//        collectionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
    }
    
    private let layout: UICollectionViewFlowLayout = {
        let guideline = UICollectionViewFlowLayout()
        guideline.scrollDirection = .vertical
        guideline.minimumLineSpacing = 9
        guideline.minimumInteritemSpacing = 0
        return guideline
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        view.scrollIndicatorInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 4)
        view.contentInset = .zero
        view.layer.backgroundColor = UIColor(red: 0.967, green: 0.967, blue: 0.967, alpha: 1).cgColor
//        view.backgroundColor = .blue
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}
