//
//  CalenderViewController.swift
//  BNomad
//
//  Created by Beone on 2022/10/19.
//

import UIKit


class VisitCardCollectionViewController: UIViewController {
    
    // MARK: - Properties
    
    static var checkInHistory: [CheckIn]? {
        didSet {
//            guard let checkinHistory = checkInHistory else { return }
//            for index in 0..<checkinHistory.count-1 {
//                if checkinHistory[index].date != checkinHistory[index+1].date {
//
//                }
//            }
        }
    }
    
    private let visitCardListView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = CustomColor.nomad2White
        collectionView.isScrollEnabled = true
        collectionView.register(VisitCardCell.self, forCellWithReuseIdentifier: VisitCardCell.identifier)
        collectionView.register(VisitCardHeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: VisitCardHeaderCollectionView.identifier)
        collectionView.alwaysBounceVertical = true
        
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
        view.backgroundColor = CustomColor.nomad2White
    }
    
    func render() {
        
        view.addSubview(visitCardListView)
        visitCardListView.frame = view.bounds
        
    }
    
}

// MARK: - UICollectionViewDataSource

extension VisitCardCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return VisitCardCollectionViewController.checkInHistory?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
}

// MARK: - UICollectionViewDelegate

extension VisitCardCollectionViewController: UICollectionViewDelegate {
    
    //draw cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VisitCardCell.identifier , for: indexPath) as? VisitCardCell else {
                return UICollectionViewCell()
            }
            
            cell.backgroundColor = .white
            cell.layer.cornerRadius = 20
            
            let checkinHistoryCount = VisitCardCollectionViewController.checkInHistory?.count
            cell.checkInHistory = VisitCardCollectionViewController.checkInHistory?[(checkinHistoryCount ?? 0)-indexPath.section-1]
            
            return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: VisitCardHeaderCollectionView.identifier, for: indexPath) as? VisitCardHeaderCollectionView else {
                    return UICollectionViewCell()
                }
        header.configure(with: VisitCardCollectionViewController.checkInHistory?[indexPath.section].date ?? "")
                return header
            
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
        
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: view.frame.size.width, height: 30)
        }
    
}
