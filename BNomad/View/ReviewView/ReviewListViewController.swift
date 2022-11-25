//
//  ReviewViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/11/07.
//

import UIKit
import Kingfisher

class ReviewListViewController: UIViewController {
    
    // MARK: - Properties

    var placeUid: String? = "" {
        didSet {
            guard let placeUid = placeUid else { return }
            FirebaseManager.shared.fetchReviewHistory(placeUid: placeUid) { reviewHistory in
                self.reviewHistory = reviewHistory
                let string = "리뷰 \(reviewHistory.count)"
                let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: string)
                let range = (string as NSString).range(of: "리뷰 ")
                attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: range)
                self.totalReviewCount.attributedText = attributedString
            }
        }
    }
    
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
    
    var reviewHistory: [Review]? = [] {
        didSet {
            collectionView.reloadData()
        }
    }
        
    var placeName: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        title.textColor = .black
        title.font = .preferredFont(forTextStyle: .headline, weight: .semibold)
        title.text = ""
        title.textAlignment = .center
        return title
    }()
    
    lazy var totalReviewCount: UILabel = {
        guard let reviewHistory = reviewHistory else { return UILabel() }
        let title = UILabel()
        title.backgroundColor = .clear
        title.textColor = CustomColor.nomadSkyblue
        title.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        title.textAlignment = .center
        let string = "리뷰 "
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
    
    var location: Int = 0
    
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
        collectionView.register(ReviewCellWithImage.self, forCellWithReuseIdentifier: ReviewCellWithImage.identifier)
        collectionView.register(ReviewCellWithoutImage.self, forCellWithReuseIdentifier: ReviewCellWithoutImage.identifier)
        navigationConfigure()
    }
    
    
    // MARK: - Helpers
    
    func navigationConfigure() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = CustomColor.nomadBlue
    }

}

// MARK: - UICollectionViewDataSource

extension ReviewListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let reviewHistory = reviewHistory else { return 7 }
        return reviewHistory.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let reviewHistory = reviewHistory else { return UICollectionViewCell() }
        if reviewHistory[indexPath.item].imageUrl != nil {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCellWithImage.identifier, for: indexPath) as? ReviewCellWithImage else { return UICollectionViewCell() }
            cell.review = reviewHistory[indexPath.item]
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCellWithoutImage.identifier, for: indexPath) as? ReviewCellWithoutImage else { return UICollectionViewCell() }
            cell.review = reviewHistory[indexPath.item]
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension ReviewListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var height: Double = 0.5 + 12 + 174 + 8 + 0 + 4 + 20 + 11
        guard let reviewHistory = reviewHistory else { return CGSize(width: view.bounds.width, height: height)}

        if reviewHistory[indexPath.item].imageUrl != nil {
            height = 0.5 + 12 + 174 + 8 + reviewHistory[indexPath.item].content.dynamicHeight() + 4 + 20 + 11
        } else {
            height = 0.5 + 12 + reviewHistory[indexPath.item].content.dynamicHeight() + 4 + 20 + 11
        }

        return CGSize(width: view.bounds.width, height: height)
    }
}
