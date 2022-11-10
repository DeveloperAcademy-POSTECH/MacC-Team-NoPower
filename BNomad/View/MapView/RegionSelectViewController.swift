//
//  RegionSelectViewController.swift
//  BNomad
//
//  Created by Youngwoong Choi on 2022/11/08.
//

import UIKit

class RegionSelectViewController: UIViewController {
    
    // MARK: - Properties

    var selectedRegion: Region?
    var regions: [Region]? = RegionData.regionArray
    var regionChangeDelegate: setMap?
    
    var rectangle: UIView = {
        let rectangle = UIView()
        rectangle.frame = CGRect(x: 0, y: 0, width: 80, height: 5)
        rectangle.layer.cornerRadius = 3
        rectangle.translatesAutoresizingMaskIntoConstraints = false
        rectangle.backgroundColor = .systemGray2
        return rectangle
    }()
    
    private let layout: UICollectionViewFlowLayout = {
        let guideline = UICollectionViewFlowLayout()
        guideline.scrollDirection = .vertical
        guideline.minimumLineSpacing = 10
        guideline.minimumInteritemSpacing = 0
        return guideline
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        view.scrollIndicatorInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        view.contentInset = .zero
        view.layer.backgroundColor = CustomColor.nomadGray3?.cgColor
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let confirmBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("확인", for: .normal)
        btn.titleLabel?.asFont(targetString: "확인", font: .preferredFont(forTextStyle: .body, weight: .bold))
        btn.backgroundColor = CustomColor.nomadBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 12
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(regionChange), for: .touchUpInside)
        return btn
    }()
    

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.backgroundColor = CustomColor.nomadGray3?.cgColor
        self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.view.layer.shadowColor = UIColor.black.cgColor
        self.view.layer.shadowOffset = .init(width: 0, height: -2)
        self.view.layer.shadowRadius = 20
        self.view.layer.shadowOpacity = 0.5
        
        self.view.addSubview(rectangle)
        self.view.addSubview(collectionView)
        self.view.addSubview(confirmBtn)

        rectangle.anchor(top: view.topAnchor, paddingTop: 15, width: 80, height: 5)
        rectangle.centerX(inView: view)
//        rectangle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        collectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 10, paddingRight: 10)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RegionCollectionViewCell.self, forCellWithReuseIdentifier: RegionCollectionViewCell.identifier)
        confirmBtn.anchor(bottom: view.bottomAnchor, paddingBottom: 30, width: 280, height: 50)
        confirmBtn.centerX(inView: view)
    }
    
    
    // MARK: - Action

    @objc func regionChange() {
        guard let selectedRegion = selectedRegion else { return }
        regionChangeDelegate?.setMapRegion(selectedRegion.lat, selectedRegion.long, spanDelta: selectedRegion.span)
        dismiss(animated: true)
    }

}

// MARK: - UICollectionViewDataSource

extension RegionSelectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let regions = regions else { return 14 }
        return regions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RegionCollectionViewCell.identifier, for: indexPath) as? RegionCollectionViewCell else { return UICollectionViewCell() }
        guard var regions = regions else { return UICollectionViewCell() }
        cell.regionBtn.text = regions[indexPath.item].name
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension RegionSelectViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let regions = regions else { return }
        selectedRegion = regions[indexPath.item]
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension RegionSelectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width/2 - 10, height: 40)

    }
}
