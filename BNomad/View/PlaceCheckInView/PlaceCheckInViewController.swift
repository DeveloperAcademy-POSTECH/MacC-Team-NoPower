//
//  ProfileListViewController.swift
//  BNomad
//
//  Created by 김예은 on 2022/10/18.
//

import UIKit

class PlaceCheckInViewController: UIViewController {
    
    // MARK: - Mock Data
    var tmpUserUid = "04d3acd1-a6ec-465e-845e-a319e42180e6"
    let placeUid = "49ab61cf-f05f-45b7-9168-8ab58983620c"
    
    var selectedPlace: Place?
    
    // MARK: - Properties
    
    var checkInList: [CheckIn]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var user: User? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var place: Place? {
        didSet {
            placeTitleLabel.text = selectedPlace?.name
            collectionView.reloadData()
        }
    }
    
    var checkIn: CheckIn? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var numberOfUsers: Int = 0
    
    private lazy var placeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = .preferredFont(forTextStyle: .headline, weight: .semibold)
        label.tintColor = CustomColor.nomadBlack
        
        return label
    }()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.layer.cornerRadius = 30 / 2
        button.tintColor = .white
        button.backgroundColor = .lightGray
        button.layer.opacity = 0.5
        button.addTarget(self, action: #selector(dismissPage), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        guard let date = "2022-10-26".toDate() else { return }
        fetchCheckInHistoryPlace(placeUid: placeUid, date: date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeCheckInView()
        configureCancelButton()
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        fetchUser(userUid: tmpUserUid)
        fetchPlaceAll()
        fetchCheckInHistoryUser(userUid: tmpUserUid)
    }
    
    // MARK: - Helpers
    
    func fetchUser(userUid: String) {
        FirebaseManager.shared.fetchUser(id: tmpUserUid) { user in
            self.user = user
        }
    }
    
    func fetchPlaceAll() {
        FirebaseManager.shared.fetchPlaceAll { place in
            print(place)
            self.place = place
        }
    }
    
    func fetchCheckInHistoryUser(userUid: String) {
        
        FirebaseManager.shared.fetchCheckInHistory(userUid: userUid) { checkInHistory in
            checkInHistory.sorted { $0.checkInTime > $1.checkInTime }
            self.checkIn = checkInHistory.last
        }
    }
    
    // MARK: - Actions
    
    @objc func dismissPage() {
        self.dismiss(animated: true)
    }

    // MARK: - Helpers
    
    func placeCheckInView() {

        view.addSubview(placeTitleLabel)
        placeTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        placeTitleLabel.anchor(top: view.topAnchor, paddingTop: 51)
        
        view.addSubview(collectionView)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(CheckedProfileListViewCell.self, forCellWithReuseIdentifier: CheckedProfileListViewCell.identifier)
        self.collectionView.register(ColorViewCell.self, forCellWithReuseIdentifier: ColorViewCell.identifier)
        self.collectionView.register(CheckInCardViewCell.self, forCellWithReuseIdentifier: CheckInCardViewCell.identifier)
        self.collectionView.register(PlaceInfoViewCell.self, forCellWithReuseIdentifier: PlaceInfoViewCell.identifier)
        self.collectionView.register(CheckedProfileListHeader.self, forCellWithReuseIdentifier: CheckedProfileListHeader.identifier)
        
        collectionView.anchor(top: placeTitleLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    func configureCancelButton() {
        view.addSubview(cancelButton)
        cancelButton.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 50, paddingRight: 20, width: 30, height: 30)
    }
    
    func fetchCheckInHistoryPlace(placeUid: String, date: Date) {
        FirebaseManager.shared.fetchCheckInHistory(placeUid: placeUid, date: date) { checkInHistory in
            self.checkInList = checkInHistory
            if let checkIn = self.checkInList {
                self.numberOfUsers = checkIn.count
                print(self.numberOfUsers)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension PlaceCheckInViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 3 {
            return self.checkInList?.count ?? 0
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let checkInCardViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckInCardViewCell.identifier, for: indexPath) as? CheckInCardViewCell else { return UICollectionViewCell() }
            checkInCardViewCell.delegate = self
            checkInCardViewCell.user = self.user
            checkInCardViewCell.checkIn = self.checkIn
            
            return checkInCardViewCell
        }
        else if indexPath.section == 1 {
            guard let placeInfoViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceInfoViewCell.identifier, for: indexPath) as? PlaceInfoViewCell else { return UICollectionViewCell() }
            placeInfoViewCell.place = selectedPlace
            return placeInfoViewCell
        }
        else if indexPath.section == 2 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckedProfileListHeader.identifier, for: indexPath) as? CheckedProfileListHeader else { return UICollectionViewCell() }
            cell.numberOfUsers = numberOfUsers
            
            return cell
        }
        else if indexPath.section == 3 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckedProfileListViewCell.identifier, for: indexPath) as? CheckedProfileListViewCell else { return UICollectionViewCell() }
            
            guard let checkIn = checkInList else { return UICollectionViewCell() }
            let userUids = checkIn.compactMap {$0.userUid}
            cell.userUid = userUids[indexPath.row]
            cell.backgroundColor = .white
            cell.layer.borderWidth = 1
            cell.layer.borderColor = CustomColor.nomadGray2?.cgColor
            cell.layer.cornerRadius = 12
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PlaceCheckInViewController: UICollectionViewDelegateFlowLayout {
    
    // cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flow = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize()
        }
        
        let viewWidth = view.bounds.width
        let sectionZeroCardHeight: CGFloat = 266
        let sectionZeroBottomPadding: CGFloat = 25
        let sectionZeroHeight = sectionZeroCardHeight + sectionZeroBottomPadding
        
        if indexPath.section == 0 {
            print(sectionZeroHeight)
            return CGSize(width: viewWidth, height: sectionZeroHeight)
        } else if indexPath.section == 1 {
            return CGSize(width: viewWidth, height: 220)
        } else if indexPath.section == 2 {
            return CGSize(width: viewWidth, height: 27)
        } else if indexPath.section == 3 {
            flow.sectionInset.top = 13
            
            return CGSize(width: 356, height: 85)
        } else {
            return CGSize(width: viewWidth, height: 0)
        }
    }
}

// MARK: - pageDismiss

extension PlaceCheckInViewController: pageDismiss {
    func checkOut() {
        self.dismiss(animated: true)
    }
}
