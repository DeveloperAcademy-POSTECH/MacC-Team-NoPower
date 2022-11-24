//
//  ProfileListViewController.swift
//  BNomad
//
//  Created by 김예은 on 2022/10/18.
//

import UIKit
import Combine

protocol ReviewPage {
    func reviewPageShow(place: Place)
}

class PlaceCheckInViewController: UIViewController {
    
    // MARK: - Mock Data
    
    var delegate: ReviewPage?
    
    lazy var viewModel: CombineViewModel = CombineViewModel.shared
    
    var selectedUser: User?
    
    var selectedPlace: Place? {
        didSet {
            guard let place = selectedPlace else { return }
            FirebaseManager.shared.fetchCheckInHistory(placeUid: place.placeUid) { checkInHistory in
                let history = checkInHistory.filter { $0.checkOutTime == nil }
                self.checkInHistory = history
                FirebaseManager.shared.fetchMeetUpHistory(placeUid: place.placeUid) { meetUpHistory in
                    self.meetUpViewModels = []
                    meetUpHistory.forEach { meetUp in
                        print("meetUpViewModels", meetUp)
                        let meetUpViewModel = MeetUpViewModel()
                        meetUpViewModel.meetUp = meetUp
                        self.meetUpViewModels?.append(meetUpViewModel)
                    }
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    var meetUpViewModels: [MeetUpViewModel]?

    var checkInHistory: [CheckIn]?

    // MARK: - Properties
    private var numberOfUsers: Int {
        checkInHistory?.count ?? 0
    }
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeCheckInView()
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        
        navigationItem.title = selectedPlace?.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissPage))
    }
    
    // MARK: - Actions
    
    @objc func dismissPage() {
        self.dismiss(animated: true)
    }

    // MARK: - Helpers
    
    func placeCheckInView() {
        
        view.addSubview(collectionView)
        collectionView.contentInsetAdjustmentBehavior = .never
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(CheckedProfileListViewCell.self, forCellWithReuseIdentifier: CheckedProfileListViewCell.identifier)
        self.collectionView.register(CheckInCardViewCell.self, forCellWithReuseIdentifier: CheckInCardViewCell.identifier)
        self.collectionView.register(PlaceInfoViewCell.self, forCellWithReuseIdentifier: PlaceInfoViewCell.identifier)
        self.collectionView.register(CheckedProfileListHeader.self, forCellWithReuseIdentifier: CheckedProfileListHeader.identifier)
        
        collectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
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
            placeInfoViewCell.meetUpViewModels = meetUpViewModels
            placeInfoViewCell.place = selectedPlace
            placeInfoViewCell.meetUpViewDelegate = self
            placeInfoViewCell.placeInfoViewCelldelegate = self
            
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
            cell.todayGoal = checkIn[indexPath.row].todayGoal
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
            return CGSize(width: viewWidth, height: 390)
        } else if indexPath.section == 1 {
            return CGSize(width: viewWidth, height: 220)
        } else if indexPath.section == 2 {
            return CGSize(width: viewWidth, height: 27)
        } else if indexPath.section == 3 {
            flow.sectionInset.top = 13
            
            return CGSize(width: 349, height: 68)
        } else {
            return CGSize(width: viewWidth, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            let controller = ProfileViewController()
            guard let nomadUid = checkInHistory?[indexPath.row].userUid else { return }
            FirebaseManager.shared.fetchUser(id: nomadUid) { user in
                controller.nomad = user
                FirebaseManager.shared.fetchCheckInHistory(userUid: nomadUid) { history in
                    controller.nomad?.checkInHistory = history
                }
            }
            controller.isMyProfile = false
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 3 {
            return CGSize(width: view.frame.size.width, height: 70)
        }
        return CGSize()
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
            guard let selectedPlace = self.selectedPlace else { return }
            self.delegate?.reviewPageShow(place: selectedPlace)
        }
    }
}

// MARK: - CheckOutAlert

extension PlaceCheckInViewController: CheckOutAlert {
    func checkOutAlert(place: Place) {
        var alert = UIAlertController(title: "체크아웃", message: "\(place.name)에서 체크아웃 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
            self.checkOut()
            FirebaseManager.shared.fetchMeetUpUidAll(userUid: self.viewModel.user?.userUid ?? "") { meetUpUid in
                FirebaseManager.shared.getPlaceUidWithMeetUpId(meetUpUid: meetUpUid) { placeUid in
                    FirebaseManager.shared.cancelMeetUp(userUid: self.viewModel.user?.userUid ?? "", meetUpUid: meetUpUid, placeUid: placeUid) {
                    }
                }
            }
        }))
        present(alert, animated: true)
    }
}

// MARK: - NewMeetUpViewShowable

extension PlaceCheckInViewController: NewMeetUpViewShowable {
    func didTapNewMeetUpButton() {
        let newMeetUpView = NewMeetUpViewController()
        newMeetUpView.placeUid = selectedPlace?.placeUid
        newMeetUpView.userUid = viewModel.user?.userUid
        newMeetUpView.isNewMeetUp = true
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: newMeetUpView)
        present(navBarOnModal, animated: true, completion: nil)
    }
}

// MARK: - PlaceInfoViewCellDelegate

extension PlaceCheckInViewController: PlaceInfoViewCellDelegate {
    func didTapMeetUpCell(_ cell: PlaceInfoViewCell, meetUpViewModel: MeetUpViewModel) {
        let vc = MeetUpViewController()
        vc.meetUpViewModel = meetUpViewModel
        navigationController?.pushViewController(vc, animated: true)
    }
}
