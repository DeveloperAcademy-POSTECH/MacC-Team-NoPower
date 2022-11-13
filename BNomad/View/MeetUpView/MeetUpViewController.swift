//
//  MeetUpViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/11/07.
//

import UIKit

class MeetUpViewController: UIViewController {

    // MARK: - Properties
    
    var meetUp: TempMeetUp?
    
    private var meetUpTitleLabel: UILabel = {
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
    
    private var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "코워킹스페이스 입구"
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = CustomColor.nomadBlack
        
        return label
    }()
    
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "12시 30분"
        label.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        label.textColor = CustomColor.nomadBlack
        
        return label
    }()
        
    lazy var locationStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [location, locationLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 14
        
        return stack
    }()
        
    lazy var timeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [time, timeLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 14
        
        return stack
    }()
    
    private var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "내용내용 맛있는 삼겹살 먹고싶은데 맛찬들 혼자가긴 좀 어쩌구저쩌구"
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    private var participants: UILabel = {
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editMeetUpContent))
        navigationController?.navigationBar.tintColor = CustomColor.nomadBlue
    }
    
    @objc func editMeetUpContent() {
        // TODO: 편집뷰로 이동
    }
    
    // MARK: - Helpers
    
    func configUI() {
        
        view.backgroundColor = .white
        
        let viewHeight = view.bounds.height
        let paddingTop = viewHeight * 160/844
        
        view.addSubview(meetUpTitleLabel)
        meetUpTitleLabel.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: paddingTop, paddingLeft: 20)
        
        view.addSubview(locationStack)
        locationStack.anchor(top: meetUpTitleLabel.bottomAnchor, left: meetUpTitleLabel.leftAnchor, paddingTop: 43)

        view.addSubview(divider)
        divider.anchor(top: location.topAnchor, bottom: locationLabel.bottomAnchor, width: 1)
        divider.centerX(inView: view)
        
        view.addSubview(timeStack)
        timeStack.anchor(top: location.topAnchor, left: divider.rightAnchor, paddingLeft: 20)
        
        view.addSubview(contentLabel)
        contentLabel.anchor(top: locationStack.bottomAnchor, left: meetUpTitleLabel.leftAnchor, right: view.rightAnchor, paddingTop: 48, paddingRight: 20)

        view.addSubview(participants)
        participants.anchor(top: contentLabel.bottomAnchor, left: meetUpTitleLabel.leftAnchor, paddingTop: 100)
        
        view.addSubview(participantCollectionView)
        participantCollectionView.anchor(top: participants.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 14, height: 130)
        
        view.addSubview(joinButton)
        joinButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 20, paddingBottom: 60, paddingRight: 20, height: 48)
    }
    
    func setMeetUpData(meetUp: TempMeetUp) {
        meetUpTitleLabel.text = meetUp.title
        locationLabel.text = meetUp.meetUpPlaceName
        timeLabel.text = meetUp.time
        contentLabel.text = meetUp.description
        participants.text = "참여 예정 노마더 ( 1 / \(meetUp.maxPeopleNum) )"
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
