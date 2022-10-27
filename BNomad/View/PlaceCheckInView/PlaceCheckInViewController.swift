//
//  ProfileListViewController.swift
//  BNomad
//
//  Created by 김예은 on 2022/10/18.
//

import UIKit

class PlaceCheckInViewController: UIViewController {
    
    // MARK: - Mock Data
    
    lazy var viewModel: CombineViewModel = CombineViewModel.shared
    
    var selectedPlace: Place? {
        didSet {
            guard let selectedPlace = selectedPlace else { return }
            FirebaseManager.shared.fetchCheckInHistory(placeUid: selectedPlace.placeUid) { checkInHistory in
                let history = checkInHistory.filter { $0.checkOutTime == nil }
                self.checkInHistory = history
            }
        }
    }
    
    var checkInHistory: [CheckIn]? {
        didSet {
            placeTitleLabel.text =  selectedPlace?.name
            guard let checkInHistory = checkInHistory else { return }
            collectionView.reloadData()
        }
    }

    // MARK: - Properties
    private var numberOfUsers: Int {
        checkInHistory?.count ?? 0
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeCheckInView()
        configureCancelButton()
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
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
        self.collectionView.register(CheckInCardViewCell.self, forCellWithReuseIdentifier: CheckInCardViewCell.identifier)
        self.collectionView.register(PlaceInfoViewCell.self, forCellWithReuseIdentifier: PlaceInfoViewCell.identifier)
        self.collectionView.register(CheckedProfileListHeader.self, forCellWithReuseIdentifier: CheckedProfileListHeader.identifier)
        
        collectionView.anchor(top: placeTitleLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    func configureCancelButton() {
        view.addSubview(cancelButton)
        cancelButton.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 50, paddingRight: 20, width: 30, height: 30)
    }
}

// MARK: - UICollectionViewDataSource

extension PlaceCheckInViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 3 {
            return self.checkInHistory?.count ?? 0
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let checkInCardViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckInCardViewCell.identifier, for: indexPath) as? CheckInCardViewCell else { return UICollectionViewCell() }
            checkInCardViewCell.checkOutDelegate = self
            checkInCardViewCell.user = viewModel.user
            checkInCardViewCell.checkIn = viewModel.user?.currentCheckIn
            
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
            
            guard let checkIn = checkInHistory else { return UICollectionViewCell() }
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

extension PlaceCheckInViewController {
    func checkOut() {
        guard var checkIn = self.viewModel.user?.currentCheckIn else { return }
        checkIn.checkOutTime = Date()
        FirebaseManager.shared.setCheckOut(checkIn: checkIn) { checkIn in
            let index = self.viewModel.user?.checkInHistory?.firstIndex { $0.checkInUid == checkIn.checkInUid }
            guard let index = index else { return }
            self.viewModel.user?.checkInHistory?[index] = checkIn
            self.dismiss(animated: true)
        }
    }
}

// MARK: - checkOutAlert

extension PlaceCheckInViewController: CheckOutAlert {
    func checkOutAlert(place: Place) {
        var alert = UIAlertController(title: "체크아웃", message: "\(place.name)에서 체크아웃 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
            self.checkOut()
        }))
        present(alert, animated: true)
    }
}
