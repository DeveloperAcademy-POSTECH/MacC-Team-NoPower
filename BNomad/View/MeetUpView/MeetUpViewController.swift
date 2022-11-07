//
//  MeetUpViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/11/07.
//

import UIKit

class MeetUpViewController: UIViewController {

    // MARK: - Properties
    
    private let meetUpTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "점심에 맛찬들 같이 가실 분"
        label.font = .preferredFont(forTextStyle: .title1, weight: .bold)
        label.textColor = CustomColor.nomadBlack
        label.numberOfLines = 1
        
        return label
    }()
    
    private let location: UILabel = {
        let label = UILabel()
        label.text = "장소"
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = CustomColor.nomadGray1
        
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.nomadGray2
        view.tintColor = CustomColor.nomadBlue
        
        return view
    }()
    
    private let time: UILabel = {
        let label = UILabel()
        label.text = "시간"
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = CustomColor.nomadGray1
        
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "코워킹스페이스 입구"
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = CustomColor.nomadBlack
        
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "12시 30분"
        label.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        label.textColor = CustomColor.nomadBlack
        
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "내용내용 맛있는 삼겹살 먹고싶은데 맛찬들 혼자가긴 좀 어쩌구저쩌구"
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    private let participants: UILabel = {
        let label = UILabel()
        label.text = "참여 예정 노마더 ( 5 / 10 )"
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = CustomColor.nomadGray1
        
        return label
    }()
    
    private let participantCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        
        collectionView.register(ParticipantCell.self, forCellWithReuseIdentifier: ParticipantCell.identifier)
        
        return collectionView
    }()
    
    private let joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("참여하기", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.backgroundColor = CustomColor.nomadBlue
        button.tintColor = .white
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configUI()
        
        participantCollectionView.dataSource = self
        participantCollectionView.delegate = self
    }
    
    // MARK: - Helpers
    
    func configUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(meetUpTitleLabel)
        meetUpTitleLabel.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 90, paddingLeft: 20)
        
        view.addSubview(location)
        location.anchor(top: meetUpTitleLabel.bottomAnchor, left: meetUpTitleLabel.leftAnchor, paddingTop: 43)

        view.addSubview(locationLabel)
        locationLabel.anchor(top: location.bottomAnchor, left: location.leftAnchor, paddingTop: 14)
        
        view.addSubview(divider)
        divider.anchor(top: location.topAnchor, bottom: locationLabel.bottomAnchor, width: 1)
        divider.centerX(inView: view)
        
        view.addSubview(time)
        time.anchor(top: location.topAnchor, left: divider.rightAnchor, paddingLeft: 20)
        
        view.addSubview(timeLabel)
        timeLabel.centerY(inView: locationLabel)
        timeLabel.anchor(left: time.leftAnchor)
        
        view.addSubview(contentLabel)
        contentLabel.anchor(top: divider.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 48, paddingLeft: 20, paddingRight: 20)

        view.addSubview(participants)
        participants.anchor(top: contentLabel.bottomAnchor, left: meetUpTitleLabel.leftAnchor, paddingTop: 100)
        
        view.addSubview(participantCollectionView)
        participantCollectionView.anchor(top: participants.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 14, height: 130)
        
        view.addSubview(joinButton)
        joinButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 20, paddingBottom: 60, paddingRight: 20, height: 48)
    }
}

// MARK: - UICollectionViewDataSource

extension MeetUpViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
}

// MARK: - UICollectionViewDelegate

extension MeetUpViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParticipantCell.identifier, for: indexPath) as? ParticipantCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .white
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MeetUpViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewWidth = participantCollectionView.frame.width
        let width = (viewWidth - 20 - 11*4)/4.5
        let height = width * 1.6
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
}
