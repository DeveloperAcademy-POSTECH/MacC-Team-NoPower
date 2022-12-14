//
//  PlaceInforViewCell.swift
//  BNomad
//
//  Created by yeekim on 2022/10/20.
//

import UIKit

protocol NewMeetUpViewShowable {
    func didTapNewMeetUpButton()
}

protocol PlaceInfoViewCellDelegate: AnyObject {
    func didTapMeetUpCell(_ cell: PlaceInfoViewCell, meetUpViewModel: MeetUpViewModel)
}

class PlaceInfoViewCell: UICollectionViewCell {
    
    static let identifier = "placeInforViewCell"
    
    // MARK: - Properties
    
    var place: Place? {
        didSet {
        }
    }
    
    weak var placeInfoViewCelldelegate: PlaceInfoViewCellDelegate?
    
    var meetUpViewModels: [MeetUpViewModel]? {
        didSet {
            guard let meetUpViewModels = meetUpViewModels else { return }
            self.sortedMeetUpViewModels = meetUpViewModels.sorted(by: { $0.meetUp?.time ?? Date() > $1.meetUp?.time ?? Date() })
            self.numberOfMeetUp = meetUpViewModels.count
            self.collectionView.reloadData()
        }
    }
    
    var sortedMeetUpViewModels: [MeetUpViewModel]?
    
    var numberOfMeetUp: Int? {
        didSet {
            guard let numberOfMeetUp = numberOfMeetUp else { return }
            numberOfQuestLabel.text = "\(numberOfMeetUp)"
        }
    }
    
    var meetUpViewDelegate: NewMeetUpViewShowable?
    
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
        label.text = "오늘의 밋업"
        label.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        label.textColor = CustomColor.nomadBlack
        return label
    }()
    
    lazy var numberOfQuestLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        label.textColor = CustomColor.nomadBlue
        
        return label
    }()
    
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(addNewMeetUp), for: .touchUpInside)
        
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
    
    @objc func addNewMeetUp() {
        meetUpViewDelegate?.didTapNewMeetUpButton()
    }
    
    // MARK: - Helpers
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        self.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor)
        collectionView.register(QuestCollectionViewCell.self, forCellWithReuseIdentifier: QuestCollectionViewCell.identifier)
        collectionView.register(NoMeetUpCell.self, forCellWithReuseIdentifier: NoMeetUpCell.identifier)
        
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
        if sortedMeetUpViewModels?.count != 0 {
            guard let meetUp = sortedMeetUpViewModels?[indexPath.item] else { return }
            placeInfoViewCelldelegate?.didTapMeetUpCell(self, meetUpViewModel: meetUp)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension PlaceInfoViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let numberOfMeetUp = numberOfMeetUp else { return 1 }
        if numberOfMeetUp > 0 {
            return numberOfMeetUp
        } else {
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let meetUpCell = collectionView.dequeueReusableCell(withReuseIdentifier: QuestCollectionViewCell.identifier, for: indexPath) as? QuestCollectionViewCell else { return UICollectionViewCell() }
        guard let noMeetUpcell = collectionView.dequeueReusableCell(withReuseIdentifier: NoMeetUpCell.identifier, for: indexPath) as? NoMeetUpCell else { return UICollectionViewCell() }
        
        if let numberOfMeetUp = numberOfMeetUp {
            if numberOfMeetUp > 0 {
                meetUpCell.meetUpViewModel = self.sortedMeetUpViewModels?[indexPath.item]
                return meetUpCell
            } else {
                return noMeetUpcell
            }
        } else {
            return noMeetUpcell
        }
    }

}
