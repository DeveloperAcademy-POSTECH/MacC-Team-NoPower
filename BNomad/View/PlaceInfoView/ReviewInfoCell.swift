//
//  ReviewInfoCell.swift
//  BNomad
//
//  Created by 유재훈 on 2022/10/20.
//

import UIKit

class ReviewInfoCell: UICollectionViewCell {
    
    // MARK: - Properties

    var reviewHistory: [Review]? {
        didSet {
            guard let reviewHistory = reviewHistory else { return }
            reviewCollectionView.reloadData()
        }
    }
    
    static let cellIdentifier = "ReviewInfoCell"
    let reviewInfoTitleLabel = UILabel()
    let reviewCountLabel = UILabel()
    let horizontalDivider1 = UILabel()
    let horizontalDivider2 = UILabel()
    let horizontalDivider3 = UILabel()
    let horizontalDivider4 = UILabel()
    let horizontalDivider5 = UILabel()
    let reviewCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let reviewCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        reviewCollectionView.backgroundColor = UIColor.white

        return reviewCollectionView
    }()
    let viewAllButton: UIButton = {
        let viewAllButton = UIButton()
        viewAllButton.setTitle("모든 리뷰 보기 ", for: .normal)
        viewAllButton.setTitleColor(CustomColor.nomadGray1, for: .normal)
        viewAllButton.semanticContentAttribute = .forceRightToLeft
        viewAllButton.titleLabel?.font = .preferredFont(forTextStyle: .footnote)
        let config = UIImage.SymbolConfiguration(pointSize: 13)
        viewAllButton.setImage(UIImage(systemName: "chevron.right", withConfiguration: config), for: .normal)
        viewAllButton.tintColor = CustomColor.nomadGray1
        
        
        return viewAllButton
    }()
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        self.addSubview(reviewInfoTitleLabel)
        self.addSubview(reviewCountLabel)
        self.addSubview(reviewCollectionView)
        self.addSubview(horizontalDivider1)
        self.addSubview(horizontalDivider2)
        self.addSubview(horizontalDivider3)
        self.addSubview(horizontalDivider4)
        self.addSubview(horizontalDivider5)
        self.addSubview(viewAllButton)
        setAttributes()
    }
    
    private func setAttributes() {
        reviewInfoTitleLabel.text = "방문자 리뷰"
        reviewInfoTitleLabel.font = UIFont.preferredFont(forTextStyle: .title3, weight: .semibold)
        reviewInfoTitleLabel.textColor = CustomColor.nomadBlack
        reviewInfoTitleLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 19, paddingLeft: 19)
        reviewCountLabel.text = "213"
        reviewCountLabel.font = UIFont.preferredFont(forTextStyle: .title3, weight: .semibold)
        reviewCountLabel.textColor = CustomColor.nomadBlue
        reviewCountLabel.anchor(top: self.topAnchor, left: reviewInfoTitleLabel.rightAnchor, paddingTop: 19, paddingLeft: 3)
        horizontalDivider1.backgroundColor = CustomColor.nomadGray2
        horizontalDivider1.anchor(top: reviewInfoTitleLabel.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 8, paddingLeft: 19, paddingRight: 19, height: 1)
        horizontalDivider2.backgroundColor = CustomColor.nomadGray2
        horizontalDivider2.anchor(top: horizontalDivider1.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 65, paddingLeft: 19, paddingRight: 19, height: 1)
        horizontalDivider3.backgroundColor = CustomColor.nomadGray2
        horizontalDivider3.anchor(top: horizontalDivider2.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 64, paddingLeft: 19, paddingRight: 19, height: 1)
        horizontalDivider4.backgroundColor = CustomColor.nomadGray2
        horizontalDivider4.anchor(top: horizontalDivider3.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 64, paddingLeft: 19, paddingRight: 19, height: 1)
        horizontalDivider5.backgroundColor = CustomColor.nomadGray2
        horizontalDivider5.anchor(top: horizontalDivider4.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 64, paddingLeft: 19, paddingRight: 19, height: 1)
        NSLayoutConstraint.activate([
            reviewCollectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            reviewCollectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            reviewCollectionView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
            reviewCollectionView.heightAnchor.constraint(equalToConstant: 500)
        ])
        reviewCollectionView.anchor(top: self.topAnchor, paddingTop: 50)
        reviewCollectionView.dataSource = self
        reviewCollectionView.delegate = self
        reviewCollectionView.register(ReviewSubCell.self, forCellWithReuseIdentifier: ReviewSubCell.cellIdentifier)
        viewAllButton.centerX(inView: contentView, topAnchor: horizontalDivider5.bottomAnchor, paddingTop: 8)
    }
}

// MARK: - UICollectionViewDataSource

extension ReviewInfoCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let reviewHistory = reviewHistory {
            return reviewHistory.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewSubCell.cellIdentifier, for: indexPath) as? ReviewSubCell else { return UICollectionViewCell() }
        cell.review = reviewHistory?[indexPath.row]
        cell.backgroundColor = UIColor.white
        return cell
    }
}


// MARK: - UICollectionViewDelegate

extension ReviewInfoCell: UICollectionViewDelegate {
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ReviewInfoCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 363, height: 60)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: 5, left: 10, bottom: 0, right: 10)
    }
}
