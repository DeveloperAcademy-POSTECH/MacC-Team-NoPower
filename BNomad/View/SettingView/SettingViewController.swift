//
//  SettingViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/11/07.
//

import UIKit
import FirebaseAuth

class SettingViewController: UIViewController {

    // MARK: - Properties
    
    enum listTitle {
        static let placeRequest = "장소 제안"
        static let withdrawUser = "회원 탈퇴"
        static let logout = "로그아웃"
    }
    
    var viewModel = CombineViewModel.shared
    
    private let settingTable: UITableView = {
        let table = UITableView()
        return table
    }()
    
    private let settingListArr: [String] = [listTitle.placeRequest, listTitle.withdrawUser, listTitle.logout]
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "설정"
        configureUI()
        configureTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "설정"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Actions
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    func configureTable() {
        settingTable.dataSource = self
        settingTable.delegate = self
        
        view.addSubview(settingTable)
        settingTable.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
    }

}

// MARK: - UITableViewDelegate

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTitle = settingListArr[indexPath.row]
        if selectedTitle == listTitle.placeRequest {
            title = ""
            let controller = PlaceRequestViewController()
            navigationController?.pushViewController(controller, animated: true)
        } else if selectedTitle == listTitle.withdrawUser {
            title = ""
            let controller = WithdrawViewController()
            navigationController?.pushViewController(controller, animated: true)
        } else if selectedTitle == listTitle.logout {
            let alert = UIAlertController(title: listTitle.logout, message: "로그아웃하면 체크인 상태가 없어지고, 참여한 밋업도 자동으로 참여 취소됩니다.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            let logout = UIAlertAction(title: "확인", style: .destructive) { action in
                if Auth.auth().currentUser != nil {
                    do {
                        try Auth.auth().signOut()
                        if self.viewModel.user?.currentCheckIn == nil {
                            self.viewModel.user = nil
                        } else {
                            guard let current = self.viewModel.user?.currentCheckIn else { return }
                            let userUid = self.viewModel.user?.userUid
                            FirebaseManager.shared.setCheckOut(checkIn: current) { checkIn in
                                let index = self.viewModel.user?.checkInHistory?.firstIndex { $0.checkInUid == checkIn.checkInUid }
                                guard let index = index else {
                                    print("fail index")
                                    return
                                }
                                self.viewModel.user?.checkInHistory?[index] = checkIn
                                self.viewModel.user = nil
                                FirebaseManager.shared.fetchMeetUpUidAll(userUid: userUid ?? "") { uid in
                                    FirebaseManager.shared.getPlaceUidWithMeetUpId(meetUpUid: uid) { placeUid in
                                        FirebaseManager.shared.cancelMeetUp(userUid: userUid ?? "", meetUpUid: uid, placeUid: placeUid) {
                                        }
                                    }
                                }
                            }
                        }
                        self.navigationController?.popToRootViewController(animated: true)
                    } catch {
                        print("No current User now")
                    }
                } else {
                    self.noUserAlert()
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
            alert.addAction(cancel)
            alert.addAction(logout)
            self.present(alert, animated: true)
        }
    }
    
    func noUserAlert() {
        let alert = UIAlertController(title: "로그아웃 오류", message: "로그인 되어 있지 않습니다.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "확인", style: .default)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let selectedTitle = settingListArr[indexPath.row]
        if selectedTitle == listTitle.logout {
            cell.textLabel?.textColor = CustomColor.nomadBlue
        } else {
            let image = UIImageView(image: UIImage(systemName: "chevron.right"))
            cell.addSubview(image)
            image.anchor(right: cell.rightAnchor, paddingRight: 10)
            image.centerY(inView: cell)
        }
        cell.textLabel?.text = selectedTitle
        cell.selectionStyle = .none
        
        return cell
    }
    
}
