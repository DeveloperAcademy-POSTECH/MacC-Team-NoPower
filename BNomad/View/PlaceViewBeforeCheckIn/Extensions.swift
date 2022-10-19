//
//  Extensions.swift
//  BottomSheet
//
//  Created by 박진웅 on 2022/10/18.
//  Copyright © 2022 Zafar. All rights reserved.
//

import UIKit

extension MyCustomViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else  { return UICollectionViewCell() }
//        cell.backgroundColor = .red
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

}

extension MyCustomViewController: UICollectionViewDelegate {
    
}

extension MyCustomViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

//        let width = itemWidth(for: view.frame.width, spacing: 0)

        return CGSize(width: view.bounds.width, height: 86)
    }

//    func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
//        let itemsInRow: CGFloat = 2
//
//        let totalSpacing: CGFloat = 2 * spacing + (itemsInRow - 1) * spacing
//        let finalWidth = (width - totalSpacing) / itemsInRow
//
//        return finalWidth - 5.0
//    }
}
