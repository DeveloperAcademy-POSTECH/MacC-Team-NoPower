//
//  PlaceInforViewCell.swift
//  BNomad
//
//  Created by yeekim on 2022/10/20.
//

import UIKit

class PlaceInfoViewCell: UICollectionViewCell {
    
    static let identifier = "placeInforViewCell"
    
    // MARK: - Properties
    
    var place: Place? {
        didSet {
//            placeNameLable.text = place?.name
            // MARK: 공지사항 data가 없어서 address으로 대체
//            placeNoteLabel.text = place?.address
            FirebaseManager.shared.fetchCheckInHistoryAll(placeUid: place?.placeUid ?? "") { checkInHistory in
//                self.visitorsLabel.text = String(checkInHistory.count) + "명"
            }
        }
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        return collectionview
    }()
    
    private let questLabel: UILabel = {
        let label = UILabel()
        label.text = "퀘스트"
        label.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        label.textColor = CustomColor.nomadBlack
        return label
    }()
    
    lazy var numberOfQuestLabel: UILabel = {
        let label = UILabel()
        label.text = "5"
        label.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        label.textColor = CustomColor.nomadBlue
        
        return label
    }()
    
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(questAdd), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCollectionView()
        configQuestLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(corder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func questAdd() {
        print("QUEST ADD!!")
    }
    
    // MARK: - Helpers
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        self.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor)
        collectionView.register(QuestCollectionViewCell.self, forCellWithReuseIdentifier: QuestCollectionViewCell.identifier)
        
//        self.addSubview(questLabel)
//        questLabel.anchor(top: collectionView.topAnchor, left: collectionView.leftAnchor, paddingTop: 10, paddingLeft: 20)
        
        self.addSubview(plusButton)
        plusButton.anchor(top: collectionView.topAnchor, right: collectionView.rightAnchor, paddingTop: 10, paddingRight: 20, width: 24, height: 24)
    }
    
    func configQuestLabel() {
        let stack = UIStackView(arrangedSubviews: [questLabel, numberOfQuestLabel])
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .leading
        stack.distribution = .fill
        
        self.addSubview(stack)
        stack.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 10, paddingLeft: 20)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PlaceInfoViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 312, height: 124)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    
}

// MARK: - UICollectionViewDataSource

extension PlaceInfoViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuestCollectionViewCell.identifier, for: indexPath) as? QuestCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
    
}
