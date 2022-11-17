//
//  ReviewInfoCell.swift
//  BNomad
//
//  Created by 유재훈 on 2022/10/20.
//

import UIKit

protocol ShowReviewListView {
    func didTapShowReviewListView()
}

class ReviewInfoCell: UICollectionViewCell {
    
    // MARK: - Properties
    var delegate: ShowReviewListView?
    
    var reviewHistory: [Review]? {
        didSet {
            guard let reviewHistory = reviewHistory else { return }
            reviewCollectionView.reloadData()
            self.reviewInfoTitleLabel.text = "방문자 리뷰 \(reviewHistory.count)"
            let fullText = reviewInfoTitleLabel.text ?? ""
            let attribtuedString = NSMutableAttributedString(string: fullText)
            let range = (fullText as NSString).range(of: "\(reviewHistory.count)")
            attribtuedString.addAttribute(.foregroundColor, value: CustomColor.nomadBlue as Any, range: range)
            reviewInfoTitleLabel.attributedText = attribtuedString
        }
    }
    
    static let cellIdentifier = "ReviewInfoCell"
    let reviewInfoTitleLabel: UILabel = {
        let reviewInfoTitleLabel = UILabel()
        reviewInfoTitleLabel.font = UIFont.preferredFont(forTextStyle: .title3, weight: .semibold)
        reviewInfoTitleLabel.textColor = CustomColor.nomadBlack
        return reviewInfoTitleLabel
    }()

    let horizontalDivider1: UILabel = {
        let horizontalDivider1 = UILabel()
        horizontalDivider1.backgroundColor = CustomColor.nomad2Separator
        return horizontalDivider1
    }()
    
    let horizontalDivider2: UILabel = {
        let horizontalDivider2 = UILabel()
        horizontalDivider2.backgroundColor = CustomColor.nomad2Separator
        return horizontalDivider2
    }()
    let horizontalDivider3: UILabel = {
        let horizontalDivider3 = UILabel()
        horizontalDivider3.backgroundColor = CustomColor.nomad2Separator
        return horizontalDivider3
    }()
    let horizontalDivider4: UILabel = {
        let horizontalDivider4 = UILabel()
        horizontalDivider4.backgroundColor = CustomColor.nomad2Separator
        return horizontalDivider4
    }()
    let horizontalDivider5: UILabel = {
        let horizontalDivider5 = UILabel()
        horizontalDivider5.backgroundColor = CustomColor.nomad2Separator
        return horizontalDivider5
    }()
    
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
        viewAllButton.addTarget(self, action: #selector(ShowReviewListView), for: .touchUpInside)
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
    
    // MARK: - Actions
    
    @objc func ShowReviewListView() {
        delegate?.didTapShowReviewListView()
    }

    
    // MARK: - Helpers
    
    private func configureUI() {
        self.addSubview(reviewInfoTitleLabel)
        self.addSubview(reviewCollectionView)
        self.addSubview(horizontalDivider1)
        self.addSubview(viewAllButton)
        setAttributes()
        
    }
    
    private func setAttributes() {
        reviewInfoTitleLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 19, paddingLeft: 19)
        horizontalDivider1.anchor(top: reviewInfoTitleLabel.bottomAnchor, paddingTop: 8, width: 360, height: 1)
        horizontalDivider1.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
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
        viewAllButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        viewAllButton.anchor(bottom: self.bottomAnchor, paddingBottom: 30)
    }
}

// MARK: - UICollectionViewDataSource

extension ReviewInfoCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count: Int = 0
        guard let reviewHistory = reviewHistory else { return 4 }
        if reviewHistory.count > 4 {
            count = 4
        } else {
            count = reviewHistory.count
        }
        return count
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
        return UIEdgeInsets (top: 10, left: 10, bottom: 10, right: 10)
    }
}
