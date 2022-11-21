//
//  ReviewViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/11/07.
//

import UIKit

class ReviewListViewController: UIViewController {
    
    // MARK: - Properties
    
    var dummyText: [String] = ["한줄 소개 입니다. 오늘 막거리 고 하나요. 어제는 집콕하며 여유를 즐겼는데~~ 오늘은 밖에서 뷰를 그리려니 심심합니다. 뭐가 난이도가 있다는 걸까요? 결국은 알아내는 사람이더라고요. WILL ZZANGZZANG 읏추 너무 춥습니다. 알쏭달쏭한 겨울입니다. 텍스트 길이제한이 없어서 아무말이나 적을 수 있답니다. 그래도 맥시멈을 설정해야할까요? 그렇게 많은 리뷰를 남길 것 같진 않은데.. 뭐 일단 해보죠!! 해봅시다 <3", "한줄 소개 입니다. 오늘 막거리 고 하나요. 어제는 집콕하며 여유를 즐겼는데~~ 오늘은 밖에서 뷰를 그리려니 심심합니다. 뭐가 난이도가 있다는 걸까요? 결국은 알아내는 사람이더라고요. WI를 남길 것 같진 않은데.. 뭐 일단 해보죠!! 해봅시다 <3", "한줄 소개 입니다.", "한줄 소개 입니다. 오너무 춥습니다. 알쏭달쏭한 겨울입니다. 텍스트 길이제한이 없어서 아무말이나 적을 수 있답니다. 그래도 맥시멈을 설정해야할까요? 그렇게 많은 리뷰를 남길 것 같진 않은데.. 뭐 일단 해보죠!! 해봅시다 <3", "화이팅!"]
    
    var dummyPhoto: [String?] = ["AppIcon", nil, "AppIcon", nil, "AppIcon"]
        
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
        collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: ReviewCell.identifier)

    }

}

// MARK: - UICollectionViewDataSource

extension ReviewListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyText.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCell.identifier, for: indexPath) as? ReviewCell else { return UICollectionViewCell() }
        cell.review.text = dummyText[indexPath.item]
        if let imageString = dummyPhoto[indexPath.item] {
            cell.photo.image = UIImage(named: imageString)
            cell.addSubview(cell.photo)
            cell.photo.anchor(top: cell.divider.bottomAnchor, left: cell.leftAnchor, right: cell.rightAnchor, paddingTop: 12, paddingLeft: 20, paddingRight: 20, height: 174)
            cell.review.anchor(top: cell.photo.bottomAnchor, left: cell.leftAnchor, right: cell.rightAnchor, paddingTop: 8, paddingLeft: 21, paddingRight: 22)
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension ReviewListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var height: Double = 0.5 + 12 + 174 + 8 + 0 + 4 + 20 + 11

        if let imageString = dummyPhoto[indexPath.item] {
            height = 0.5 + 12 + 174 + 8 + dummyText[indexPath.item].dynamicHeight() + 4 + 20 + 11
        } else {
            height = 0.5 + 12 + dummyText[indexPath.item].dynamicHeight() + 4 + 20 + 11
        }

        return CGSize(width: view.bounds.width, height: height)
    }
}
