//
//  CalenderViewController.swift
//  BNomad
//
//  Created by Beone on 2022/10/19.
//

import UIKit


class VisitCardCollectionViewController: UIViewController {
    
    // MARK: - Properties
    
    static var checkInHistory: [CheckIn]?
    
    
    private let visitCardListView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(hex: "F5F5F5")
        collectionView.isScrollEnabled = true
        collectionView.register(VisitingInfoCell.self, forCellWithReuseIdentifier: VisitingInfoCell.identifier)
        
        return collectionView
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        visitCardListView.dataSource = self
        visitCardListView.delegate = self
        
        configureUI()
        render()
    
    }
    
    
    // MARK: - Actions
    
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = UIColor(hex: "F5F5F5")
    }
    
    func render() {
        
        view.addSubview(visitCardListView)
        visitCardListView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor,
                                 paddingTop: 100, paddingLeft: 14, paddingRight: 14)
        
    }
    
}

// MARK: - UICollectionViewDataSource

extension VisitCardCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return VisitCardCollectionViewController.checkInHistory?.count ?? 0
    }
    
}

// MARK: - UICollectionViewDelegate

extension VisitCardCollectionViewController: UICollectionViewDelegate {
    
    //draw cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VisitingInfoCell.identifier , for: indexPath) as? VisitingInfoCell else {
                return UICollectionViewCell()
            }
            
            cell.backgroundColor = .systemBackground
            cell.layer.cornerRadius = 20
            
            let checkinHistoryCount = VisitCardCollectionViewController.checkInHistory?.count
            cell.checkinHistoryForList = VisitCardCollectionViewController.checkInHistory?[(checkinHistoryCount ?? 0)-indexPath.item-1]
            
            return cell
        
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension VisitCardCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 358, height: 119)
    }
    
    //cell 횡간 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return CGFloat(0)
    }
    
    //cell 종간 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(20)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
}
