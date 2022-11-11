//
//  ReviewViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/11/07.
//

import UIKit

class ReviewListViewController: UIViewController {
    
    // MARK: - Properties

    private var placeName: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        title.textColor = .black
        title.font = .preferredFont(forTextStyle: .headline, weight: .semibold)
        title.text = "쌍사벅스"
        title.textAlignment = .center
        return title
    }()
    
    private var totalReviewCount: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        title.textColor = CustomColor.nomadSkyblue
        title.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        title.textAlignment = .center
        let string = "리뷰 213"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: string)
        let range = (string as NSString).range(of: "리뷰 ")
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: range)
        title.attributedText = attributedString
        return title
    }()
    
    private let layout: UICollectionViewFlowLayout = {
        let guideline = UICollectionViewFlowLayout()
        guideline.scrollDirection = .vertical
        guideline.minimumLineSpacing = 0
        guideline.minimumInteritemSpacing = 0
        guideline.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return guideline
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        view.scrollIndicatorInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 4)
        view.contentInset = .zero
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(placeName)
        placeName.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: 54)
        view.addSubview(totalReviewCount)
        totalReviewCount.anchor(top: placeName.bottomAnchor, left: view.leftAnchor,paddingTop: 24, paddingLeft: 21)
        view.addSubview(collectionView)
        collectionView.anchor(top: totalReviewCount.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: ReviewCell.identifier)

    }
    

}


// MARK: - UICollectionViewDataSource

extension ReviewListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCell.identifier, for: indexPath) as? ReviewCell else { return UICollectionViewCell() }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension ReviewListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCell.identifier, for: indexPath) as? ReviewCell else { return CGSize(width: 350, height: 150) }
        return CGSize(width: view.bounds.width, height: 350)
    }
}
