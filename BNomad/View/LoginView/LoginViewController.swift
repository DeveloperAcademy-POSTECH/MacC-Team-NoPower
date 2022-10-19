//
//  LoginViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/10/17.
//

import AuthenticationServices
import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let logoView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "tempLogo")
        
        return view
    }()
    
    private let loginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
        button.cornerRadius = 50
        
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        setupProviderLoginView()
    }
    
    // MARK: - Methods
    
    func setupProviderLoginView() {
        loginButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
    }
    
    func configUI() {
        let viewWidth = view.bounds.width
        let viewHeight = view.bounds.height
        let imageWidth = viewWidth * 196/390
        let imageHeight = viewHeight * 33/844
        let buttonWidth = viewWidth * 268/390
        let buttonHeight = viewHeight * 50/844
        let buttonBottom = viewHeight * 143/844
        
        view.backgroundColor = .white
        
        view.addSubview(logoView)
        logoView.center(inView: view)
        logoView.setDimensions(height: imageHeight, width: imageWidth)
        
        view.addSubview(loginButton)
        loginButton.centerX(inView: logoView)
        loginButton.anchor(bottom: view.bottomAnchor, paddingBottom: buttonBottom, width: buttonWidth, height: buttonHeight)
    }
    
    @objc func handleAuthorizationAppleIDButtonPress() {
        print(#function)
    }
}
