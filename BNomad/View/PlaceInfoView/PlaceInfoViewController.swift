//
//  PlaceViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/10/17.
//

import UIKit

class PlaceInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var pinButton: UIButton = {
        let button = UIButton()
        button.setTitle("장소핀", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(didTapPinButton), for: .touchUpInside)
        
        return button
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
        view.addSubview(pinButton)
        pinButton.translatesAutoresizingMaskIntoConstraints = false
        pinButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 45, paddingLeft: 18)

        }
    
    // MARK: - Helpers
    
    @objc func didTapPinButton() {
        showMyViewController()
    }
    
            func showMyViewController() {
//                let navigationController = UINavigationController(rootViewController: PlaceInfoViewModalViewController())
                present(PlaceInfoModalViewController(), animated: true, completion: nil)
    }
             }
     

    // MARK: - PlaceInfoViewController

extension PlaceInfoViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {

    }
}


