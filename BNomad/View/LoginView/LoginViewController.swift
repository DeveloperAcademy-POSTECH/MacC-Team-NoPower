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
    
    private let loginTitle: UILabel = {
        let label = UILabel()
        label.text = "로그인이 필요합니다!"
        label.font = .preferredFont(forTextStyle: .title1, weight: .bold)
        return label
    }()
    
    private let reasonDescription: UILabel = {
        let label = UILabel()
        label.text = "업무공간 체크인, 퀘스트 참여 등을 위해 회원가입 및 로그인을 해주세요. 추후에 프로필, 체크인에 따라 다르게 바꿀예정"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .body, weight: .regular)
        return label
    }()
    
    private let loginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
        button.cornerRadius = 100
        return button
    }()
    
    private lazy var laterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음에 하기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.setUnderline()
        button.tintColor = CustomColor.nomadGray1
        button.addTarget(self, action: #selector(later), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        loginButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        
    }
    
    // MARK: - Action
    
    @objc func later() {
        self.dismiss(animated: true)
    }
    
    @objc func handleAuthorizationAppleIDButtonPress() {
        let appleIDprovider = ASAuthorizationAppleIDProvider()
        let request = appleIDprovider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    // MARK: - Methods
    
    func configUI() {
        view.backgroundColor = .systemBackground
    
        view.addSubview(loginTitle)
        loginTitle.anchor(top: view.topAnchor, paddingTop: 80)
        loginTitle.centerX(inView: view)
        
        view.addSubview(reasonDescription)
        reasonDescription.anchor(top: loginTitle.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 26, paddingLeft: 60, paddingRight: 60)
        reasonDescription.centerX(inView: view)
        
        view.addSubview(loginButton)
        loginButton.anchor(top: reasonDescription.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 47, paddingLeft: 60, paddingRight: 60, height: 50)
        
        view.addSubview(laterButton)
        laterButton.anchor(top: loginButton.bottomAnchor, paddingTop: 33, width: 100, height: 30)
        laterButton.centerX(inView: view)
        
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            print("#1 userIdentifier: \(userIdentifier)")
            print("#2 fullName: \(String(describing: fullName))")
            print("#3 email: \(String(describing: email))")
            
            // TODO: 추후 이 modal을 내리고 SignUpViewController를 띄우기 위함
            // self.dismiss(animated: true)
            
            let signUpViewController = SignUpViewController()
            signUpViewController.modalPresentationStyle = .fullScreen
            present(signUpViewController, animated: true)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return self.view.window!
    }
}

// MARK: - UIButton+setUnderline
// REF: https://ios-development.tistory.com/742

extension UIButton {
    func setUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: title.count))
        setAttributedTitle(attributedString, for: .normal)
    }
}
