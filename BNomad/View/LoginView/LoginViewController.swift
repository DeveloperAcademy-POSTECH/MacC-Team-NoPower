//
//  LoginViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/10/17.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let logoView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "tempLogo")
        
        return view
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configLogo()
    }
    
    // MARK: - Methods
    
    func configLogo() {
        let viewWidth = view.bounds.width
        let viewHeight = view.bounds.height
        let imageWidth = viewWidth * 196/390
        let imageHeight = viewHeight * 33/844
        
        view.addSubview(logoView)
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logoView.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
    }
}
