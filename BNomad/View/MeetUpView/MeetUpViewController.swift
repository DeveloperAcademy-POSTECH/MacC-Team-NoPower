//
//  MeetUpViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/11/07.
//

import UIKit

class MeetUpViewController: UIViewController {

    // MARK: - Properties
    
    let viewModel = CombineViewModel.shared
    
    var meetUpViewModel: MeetUpViewModel? {
        didSet {
            guard let meetUp = meetUpViewModel?.meetUp else { return }
            organizerUid = meetUp.organizerUid
            currentPeopleUids = meetUp.currentPeopleUids
            meetUpTitleLabel.text = meetUp.title
            locationLabel.text = meetUp.meetUpPlaceName
            timeLabel.text = meetUp.time.toTimeString()
            contentLabel.text = meetUp.description
            participants.text = "참여 예정 노마드 ( \(meetUp.currentPeopleUids?.count ?? 0) / \(meetUp.maxPeopleNum) )"
            participantCollectionView.reloadData()
            
            guard let participants = currentPeopleUids else { return }
            guard let user = viewModel.user?.userUid else { return }
                
            if participants.contains(user) {
                configJoinCancelButton()
            }
            
        }
    }
    
    var organizerUid: String?
    var currentPeopleUids: [String]?
    
    private var meetUpTitleLabel: UILabel = {
        let label = UILabel()
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
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = CustomColor.nomadBlack
        
        return label
    }()
    
    private var timeLabel: UILabel = {
        let label = UILabel()
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
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    private var participants: UILabel = {
        let label = UILabel()
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
    
    private lazy var joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("참여하기", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.backgroundColor = CustomColor.nomadBlue
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(joinMeetUp), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configUI()
        configEditButton()
        
        participantCollectionView.dataSource = self
        participantCollectionView.delegate = self
        
        navigationController?.navigationBar.tintColor = CustomColor.nomadBlue
    }
    
    // MARK: - Actions
    
    @objc func editMeetUpContent() {
        let controller = NewMeetUpViewController()
        controller.isNewMeetUp = false
        controller.meetUpViewModel = meetUpViewModel
        self.navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func joinMeetUp() {
        let alert = UIAlertController(title: "\(meetUpTitleLabel.text ?? "")에 참여 하시겠습니까?", message: "MeetUp에 참여합니다.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let join = UIAlertAction(title: "확인", style: .default, handler: { action in
            guard
                let userUid = self.viewModel.user?.userUid,
                let meetUpUid = self.meetUpViewModel?.meetUp?.meetUpUid,
                let placeUid = self.meetUpViewModel?.meetUp?.placeUid,
                let currentPeopleUids = self.meetUpViewModel?.meetUp?.currentPeopleUids,
                let maxPeopleNum = self.meetUpViewModel?.meetUp?.maxPeopleNum
            else { return }
            
            if maxPeopleNum > currentPeopleUids.count {
                FirebaseManager.shared.participateMeetUp(userUid: userUid, meetUpUid: meetUpUid, placeUid: placeUid) {
                    self.meetUpViewModel?.meetUp?.currentPeopleUids?.append(userUid)
                }
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                let maxAlert = UIAlertController(title: "모집인원 초과", message: "모집인원을 초과하여 참여할 수 없습니다.", preferredStyle: .alert)
                maxAlert.addAction(UIAlertAction(title: "확인", style: .default))
                self.present(maxAlert, animated: true)
            }
        })
        alert.addAction(cancel)
        alert.addAction(join)
        self.present(alert, animated: true)
    }
    
    @objc func cancelJoinMeetUp() {
        let alert = UIAlertController(title: "밋업 참여 취소", message: "\"\(meetUpTitleLabel.text ?? "")\" 밋업 참여를 취소합니다.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let cancelJoin = UIAlertAction(title: "확인", style: .default, handler: { action in
            guard
                let userUid = self.viewModel.user?.userUid,
                let meetUpUid = self.meetUpViewModel?.meetUp?.meetUpUid,
                let placeUid = self.meetUpViewModel?.meetUp?.placeUid
            else { return }
            FirebaseManager.shared.cancelMeetUp(userUid: userUid, meetUpUid: meetUpUid, placeUid: placeUid) { }
            
            self.navigationController?.popToRootViewController(animated: true)
        })
        alert.addAction(cancel)
        alert.addAction(cancelJoin)
        self.present(alert, animated: true)
    }
    
    // MARK: - Helpers
    
    func configEditButton() {
        guard let userUid = viewModel.user?.userUid else { return }
        guard let organizerUid = meetUpViewModel?.meetUp?.organizerUid else { return }
        if userUid == organizerUid {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editMeetUpContent))
        }
    }

    func configJoinCancelButton() {
        joinButton.setTitle("참여 취소", for: .normal)
        joinButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        joinButton.backgroundColor = CustomColor.nomad2White
        joinButton.layer.borderWidth = 1
        joinButton.layer.borderColor = CustomColor.nomadBlue?.cgColor
        joinButton.setTitleColor(CustomColor.nomadBlue, for: .normal)
        joinButton.removeTarget(self, action: #selector(joinMeetUp), for: .touchUpInside)
        joinButton.addTarget(self, action: #selector(cancelJoinMeetUp), for: .touchUpInside)
    }
    
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
    
}

// MARK: - UICollectionViewDataSource

extension MeetUpViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meetUpViewModel?.meetUp?.currentPeopleUids?.count ?? 0
    }
}

// MARK: - UICollectionViewDelegate

extension MeetUpViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParticipantCell.identifier, for: indexPath) as? ParticipantCell else {
            return UICollectionViewCell()
        }
        
        var people: [String] = []
        if let originalPeople = meetUpViewModel?.meetUp?.currentPeopleUids, let organizerUid = organizerUid {
            people = originalPeople
            if let index = people.firstIndex(of: organizerUid) {
                people.remove(at: index)
                people.insert(organizerUid, at: 0)
            }
        }
        cell.organizerUid = organizerUid
        cell.userUid = people[indexPath.row]
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
