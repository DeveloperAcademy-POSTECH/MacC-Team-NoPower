//
//  LoginViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/10/17.
//

import AuthenticationServices
import CryptoKit
import UIKit
import FirebaseAuth
import Firebase

protocol LogInToSignUp {
    func logInToSignUp(userIdentifier: String)
}

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    fileprivate var currentNonce: String?
    var delegate: LogInToSignUp?
    var viewModel = CombineViewModel.shared

    private let loginTitle: UILabel = {
        let label = UILabel()
        label.text = "로그인이 필요합니다!"
        label.font = .preferredFont(forTextStyle: .title1, weight: .bold)
        return label
    }()
    
    private let reasonDescription: UILabel = {
        let label = UILabel()
        label.text = "업무공간 체크인, 밋업 참여 등을 위해 회원가입 및 로그인을 해주세요."
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
        let request = createAppleIDRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
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
            print("email", appleIDCredential.email as Any)
            print("fullname", appleIDCredential.fullName?.description as Any)
            
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            guard let appleIDtoken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            
            guard let idTokenString = String(data: appleIDtoken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDtoken.debugDescription)")
                return
            }
            
            print(idTokenString)
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                                       idToken: idTokenString,
                                                                       rawNonce: nonce)
            Auth.auth().signIn(with: credential) { (authDataResult, error) in
                if let user = authDataResult?.user {
                    print("애플 로그인 성공!", user.uid, user.email ?? "-")
                    FirebaseManager.shared.checkUserExist(userUid: user.uid) { isExist in
                        if isExist {
                            FirebaseManager.shared.fetchUser(id: user.uid) { user in
                                self.viewModel.user = user
                                FirebaseManager.shared.fetchCheckInHistory(userUid: user.userUid) { checkInHistory in
                                    self.viewModel.user?.checkInHistory = checkInHistory
                                }
                            }
                            self.dismiss(animated: true)
                        } else {
                            self.dismiss(animated: true)
                            self.delegate?.logInToSignUp(userIdentifier: user.uid)
                        }
                    }
                }
                if error != nil {
                    print(error?.localizedDescription ?? "error" as Any)
                    return
                }
            }
        } else {
            print("ERRRRRR")
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

extension LoginViewController {
    @available(iOS 13, *)
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        // 애플로그인은 사용자에게서 2가지 정보를 요구함
        request.requestedScopes = [.fullName, .email]
        
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        
        return request
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
}
