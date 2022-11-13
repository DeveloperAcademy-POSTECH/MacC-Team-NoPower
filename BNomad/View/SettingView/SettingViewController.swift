//
//  SettingViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/11/07.
//

import UIKit

class SettingViewController: UIViewController {

    // MARK: - Properties
    
    enum listTitle {
        static let placeRequest = "장소 제안"
        static let withdrawUser = "회원 탈퇴"
        static let logout = "로그아웃"
    }
    
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
            let alert = UIAlertController(title: listTitle.logout, message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            let logout = UIAlertAction(title: "확인", style: .destructive) { action in
                // TODO: 로그아웃 액션
                self.navigationController?.popToRootViewController(animated: true)
            }
            alert.addAction(cancel)
            alert.addAction(logout)
            self.present(alert, animated: true)
        }
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
