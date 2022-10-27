//
//  ViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/10/13.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var viewModel: CombineViewModel = CombineViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        handleLogin()
    }
    
    func handleLogin() {
        let deviceUid = UIDevice.current.identifierForVendor?.uuidString
        guard let deviceUid = deviceUid else { return }
            
        FirebaseManager.shared.checkUserExist(userUid : deviceUid) { isExist in
            if isExist {
                self.fetchUserAndCheckInHistory(id: deviceUid)
            } else {
                print("no user")
                let mapViewController = MapViewController()
                self.navigationController?.pushViewController(mapViewController, animated: true)
            }
        }
    }
    
    func fetchUserAndCheckInHistory(id userUid: String) {
        FirebaseManager.shared.fetchUser(id: userUid) { user in
            self.viewModel.user = user
            FirebaseManager.shared.fetchCheckInHistory(userUid: userUid) { checkInHistory in
                //                print("checkInHistory", checkInHistory)
                self.viewModel.user?.checkInHistory = checkInHistory
                print("checkIn 유무", self.viewModel.user?.isChecked)
                
                let mapViewController = MapViewController()
                self.navigationController?.pushViewController(mapViewController, animated: true)
            }
        }
    }
}
