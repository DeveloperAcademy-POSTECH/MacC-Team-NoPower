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
    func didTapMeetUpCell(_ cell: PlaceInfoViewCell, viewModel: TempMeetUp)
}

// TODO: TempMeetUp, TempMeetUpData는 QuestCollectionViewCell과 MeetUpView로의 연결작업을 위한 임의 데이터이며, 추후 실제 데이터 연결 필요
struct TempMeetUp {
    var title: String
    var meetUpPlaceName: String
    var time: String
    var maxPeopleNum: Int
    var description: String
}

struct TempMeetUpData {
    var list = [
        TempMeetUp(title: "점심에 맛찬들 가실 분~", meetUpPlaceName: "정문 앞", time: "12:30", maxPeopleNum: 4, description: "갑자기 삼겹살이 땡기는데 맛찬들 혼자가긴 좀 그렇네요 같이 가실 분 구합니다!"),
        TempMeetUp(title: "탁구 30분만 치실 분", meetUpPlaceName: "탁구대 앞", time: "14:30", maxPeopleNum: 2, description: "점심먹으니 졸리네요.. 잠도 깰겸 탁구 30분만 딱 치고 다시 집중하고 싶어요~"),
        TempMeetUp(title: "iOS 개발자 계신가요?", meetUpPlaceName: "휴게실", time: "15:00", maxPeopleNum: 3, description: "오늘 여기 사람이 많네요. 혹시 iOS 개발자도 계신지 궁금합니다! 저는 디자이너예요ㅎ")
    ]
}

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
    
    weak var placeInfoViewCelldelegate: PlaceInfoViewCellDelegate?
    var meetUpList = TempMeetUpData().list
    
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
        label.text = "퀘스트"
        label.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        label.textColor = CustomColor.nomadBlack
        return label
    }()
    
    lazy var numberOfQuestLabel: UILabel = {
        let label = UILabel()
        label.text = "\(meetUpList.count)"
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
        collectionView.backgroundColor = .systemBackground
        collectionView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor)
        collectionView.register(QuestCollectionViewCell.self, forCellWithReuseIdentifier: QuestCollectionViewCell.identifier)
        
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
        let meetUp = meetUpList[indexPath.item]
        placeInfoViewCelldelegate?.didTapMeetUpCell(self, viewModel: meetUp)
    }
}

// MARK: - UICollectionViewDataSource

extension PlaceInfoViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meetUpList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuestCollectionViewCell.identifier, for: indexPath) as? QuestCollectionViewCell else { return UICollectionViewCell() }
        
        let meetUpData = self.meetUpList[indexPath.item]
        cell.updateMeetUpCell(meetUp: meetUpData)
        
        return cell
    }
    
}
