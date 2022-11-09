//
//  SignUpViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/10/17.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var viewModel: CombineViewModel = CombineViewModel.shared
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.layer.cornerRadius = 30 / 2
        button.tintColor = .white
        button.backgroundColor = .lightGray
        button.layer.opacity = 0.5
        button.addTarget(self, action: #selector(dismissPage), for: .touchUpInside)
        if RCValue.shared.bool(forKey: ValueKey.isLoginFirst) { 
            button.isHidden = true 
        }
        return button
    }()

    private let requestItem = ["닉네임", "직업", "상태", "멋진 사진"]
    private let requestSentence = ["닉네임을 알려주세요!", "직업을 알려주세요!", "상태를 알려주세요!", "멋진 사진을 올려주세요!"]
    private var index = 0
    private let nicknameLimit = 20
    private let occupationLimit = 40
    private let statusLimit = 150
    private let introPlaceholder = "자기소개를 작성해주세요!"
        
    lazy var requestLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1, weight: .bold)
        label.numberOfLines = 2
        
        return label
    }()
    
    lazy var dot1View: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        view.backgroundColor = CustomColor.nomadBlue
        view.layer.cornerRadius = 2.5
        view.contentMode = .scaleAspectFit

        return view
    }()
    
    lazy var dot2View: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        view.backgroundColor = CustomColor.nomadGray2
        view.layer.cornerRadius = 2.5
        view.contentMode = .scaleAspectFit

        return view
    }()
    
    lazy var dot3View: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        view.backgroundColor = CustomColor.nomadGray2
        view.layer.cornerRadius = 2.5
        view.contentMode = .scaleAspectFit

        return view
    }()
    
    lazy var dotsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dot1View, dot2View, dot3View])
        stackView.axis = .horizontal
        stackView.spacing = 8.0
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        stackView.backgroundColor = .clear

        dot1View.anchor(width: 5, height: 5)
        dot2View.anchor(width: 5, height: 5)
        dot3View.anchor(width: 5, height: 5)

        return stackView
    }()

    private var nicknameField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "닉네임"
        textfield.font = .preferredFont(forTextStyle: .title3)
        textfield.borderStyle = .none
        textfield.clearButtonMode = .whileEditing
        
        return textfield
    }()
    
    private var nicknameLineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.nomadGray1
        
        return view
    }()
    
    private lazy var nicknameCounterLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        label.text = "0 / \(nicknameLimit)"
        label.textColor = CustomColor.nomadGray1
        
        return label
    }()
    
    private let occupationField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "직업"
        textfield.font = .preferredFont(forTextStyle: .title3)
        textfield.borderStyle = .none
        textfield.clearButtonMode = .whileEditing
        
        return textfield
    }()
    
    private var occupationLineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.nomadGray1
        
        return view
    }()
    
    private lazy var occupationCounterLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        label.text = "0 / \(occupationLimit)"
        label.textColor = CustomColor.nomadGray1
        
        return label
    }()
    
    private let statusField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "커피챗 환영합니다:)"
        textfield.font = .preferredFont(forTextStyle: .title3)
        textfield.borderStyle = .none
        textfield.clearButtonMode = .whileEditing
        
        return textfield
    }()
    
    private var statusLineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.nomadGray1
        
        return view
    }()
    
    private lazy var introductionField: UITextView = {
        let textView = UITextView()
        textView.text = introPlaceholder
        textView.textColor = .tertiaryLabel
        textView.font = .preferredFont(forTextStyle: .footnote)
        textView.backgroundColor = .clear
        
        return textView
    }()
    
    private var introRectangle: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 2
        view.layer.borderColor = CustomColor.nomadBlue?.cgColor
        
        return view
    }()
    
    private lazy var statusCounterLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        label.text = "0 / \(statusLimit)"
        label.textColor = CustomColor.nomadGray1
        
        return label
    }()
    
    private var inputConfirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body, weight: .semibold)
        button.backgroundColor = CustomColor.nomadBlue
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    private lazy var keyboardAccView: UIView = {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 58))
        
//        view.addSubview(inputConfirmButton)
        
        
        return view
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Analytics.logEvent("signUpViewLoaded", parameters: [
            AnalyticsParameterItemName: "signUpViewLoaded",
          ])

        configUI()
        
        view.addSubview(dotsStackView)
        dotsStackView.anchor(
            bottom: requestLabel.bottomAnchor,
            right: nicknameField.rightAnchor,
            paddingBottom: 0,
            paddingRight: 0
        )

        nicknameField.delegate = self
        occupationField.delegate = self
        statusField.delegate = self
        introductionField.delegate = self
        
        occupationField.isHidden = true
        occupationLineView.isHidden = true
        occupationCounterLabel.isHidden = true
        statusField.isHidden = true
        statusLineView.isHidden = true
        statusCounterLabel.isHidden = true
        introRectangle.isHidden = true
        introductionField.isHidden = true
        
        inputConfirmButton.addTarget(self, action: #selector(didTapInputConfirmButton), for: .touchUpInside)
        
        hideKeyboardWhenTappedAround()
        configCancelButton()
    }
    
    // MARK: - Methods
    
    func setUser(nickname: String, occupation: String, intro: String) -> User? {
        let deviceUid = UIDevice.current.identifierForVendor?.uuidString
        guard let userUid = deviceUid else { return nil}
        
        let user = User(userUid: userUid, nickname: nickname, occupation: occupation, introduction: intro)
        FirebaseManager.shared.setUser(user: user)
        return user
    }
    
    func configUI() {
        let viewWidth = view.bounds.width
        let contentInset: CGFloat = 24
        let textFieldWidth: CGFloat = viewWidth - (contentInset * 2)
        let textFieldTopSpacing: CGFloat = 45
        let textFieldLineSpacing: CGFloat = 8
        let lineHeight: CGFloat = 2
        
        view.backgroundColor = .white
        
        view.addSubview(requestLabel)
        updateRequestLabel(index: index)
        requestLabel.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 87, paddingLeft: contentInset)
        requestLabel.asColor(targetString: requestItem[0], color: CustomColor.nomadBlue ?? .label)

        view.addSubview(nicknameField)
        nicknameField.inputAccessoryView = keyboardAccView
        nicknameField.anchor(
            top: requestLabel.bottomAnchor,
            left: requestLabel.leftAnchor,
            paddingTop: 64,
            paddingLeft: 0,
            width: textFieldWidth
        )
        nicknameField.becomeFirstResponder()
        
        view.addSubview(nicknameLineView)
        nicknameLineView.anchor(
            top: nicknameField.bottomAnchor,
            left: requestLabel.leftAnchor,
            paddingTop: textFieldLineSpacing,
            paddingLeft: 0, width: textFieldWidth,
            height: lineHeight
        )
        
        view.addSubview(nicknameCounterLabel)
        nicknameCounterLabel.anchor(
            top: nicknameLineView.bottomAnchor,
            right: nicknameLineView.rightAnchor,
            paddingTop: 8
        )
        
        view.addSubview(occupationField)
        occupationField.inputAccessoryView = keyboardAccView
        occupationField.anchor(
            top: nicknameField.bottomAnchor,
            left: requestLabel.leftAnchor,
            paddingTop: textFieldTopSpacing,
            paddingLeft: 0,
            width: textFieldWidth
        )
        
        view.addSubview(occupationLineView)
        occupationLineView.anchor(
            top: occupationField.bottomAnchor,
            left: requestLabel.leftAnchor,
            paddingTop: textFieldLineSpacing,
            paddingLeft: 0,
            width: textFieldWidth,
            height: lineHeight
        )
        
        view.addSubview(occupationCounterLabel)
        occupationCounterLabel.anchor(
            top: occupationLineView.bottomAnchor,
            right: occupationLineView.rightAnchor,
            paddingTop: 8
        )
        
        view.addSubview(statusField)
        statusField.inputAccessoryView = keyboardAccView
        statusField.anchor(
            top: occupationField.bottomAnchor,
            left: requestLabel.leftAnchor,
            paddingTop: textFieldTopSpacing,
            paddingLeft: 0,
            width: textFieldWidth
        )
        
        view.addSubview(statusLineView)
        statusLineView.anchor(
            top: statusField.bottomAnchor,
            left: requestLabel.leftAnchor,
            paddingTop: textFieldLineSpacing,
            paddingLeft: 0,
            width: textFieldWidth,
            height: lineHeight
        )
        
        view.addSubview(introRectangle)
        introRectangle.anchor(
            top: occupationField.bottomAnchor,
            left: requestLabel.leftAnchor,
            paddingTop: textFieldTopSpacing,
            width: textFieldWidth,
            height: 106
        )
        
        view.addSubview(introductionField)
        introductionField.inputAccessoryView = keyboardAccView
        introductionField.anchor(
            top: introRectangle.topAnchor,
            left: introRectangle.leftAnchor,
            bottom: introRectangle.bottomAnchor,
            right: introRectangle.rightAnchor,
            paddingTop: 4,
            paddingLeft: 8,
            paddingBottom: 4,
            paddingRight: 8
        )
        
        view.addSubview(statusCounterLabel)
        statusCounterLabel.anchor(
            top: introRectangle.bottomAnchor,
            right: introRectangle.rightAnchor,
            paddingTop: 8
        )
        
//        keyboardAccView.addSubview(inputConfirmButton)
        
//        guard let inputConfirmButtonSuperview = inputConfirmButton.superview
//        else {
//            return
//        }
//
//        inputConfirmButton.anchor(
//            top: inputConfirmButtonSuperview.topAnchor,
//            left: inputConfirmButtonSuperview.leftAnchor,
//            right: inputConfirmButtonSuperview.rightAnchor,
//            paddingLeft: 20,
//            paddingRight: 20,
//            height: 48
//        )

    }
    
    func updateRequestLabel(index: Int) {
        requestLabel.text = "노마드가 되기 위해\n\(requestSentence[index])"
    }
    
    func showAlert() {
        let alertLabel = UILabel()
        alertLabel.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        alertLabel.text = "빈칸없이 입력해주세요!"
        alertLabel.textColor = .red
        alertLabel.alpha = 1.0
        self.view.addSubview(alertLabel)
        alertLabel.anchor(
            top: introRectangle.bottomAnchor,
            left: introRectangle.leftAnchor,
            paddingTop: 8
        )

        UIView.animate(withDuration: 1.0, delay: 1, options: .curveEaseOut, animations: {
            alertLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            alertLabel.removeFromSuperview()
        })
    }
    
    func configCancelButton() {
        view.addSubview(cancelButton)
        cancelButton.anchor(
            top: view.topAnchor,
            right: view.rightAnchor,
            paddingTop: 50,
            paddingRight: 20,
            width: 30,
            height: 30
        )
    }
    
    
    // MARK: - Actions
    
    @objc func dismissPage() {
        self.dismiss(animated: true)
    }
    
    // TODO: - 입력된 user 정보 기반을 user 생성 & firebase에 user 정보 업데이트
    @objc func didTapInputConfirmButton() {
        if occupationField.isHidden == true {
            if nicknameField.text?.isEmpty == true {
                print("닉네임을 입력하세요.")
            } else {
                occupationField.isHidden = false
                occupationLineView.isHidden = false
                occupationCounterLabel.isHidden = false
                occupationField.becomeFirstResponder()
                dot1View.backgroundColor = CustomColor.nomadGray2
                dot2View.backgroundColor = CustomColor.nomadBlue
                
                index = 1
                updateRequestLabel(index: index)
                requestLabel.asColor(targetString: requestItem[index], color: CustomColor.nomadBlue ?? .label)
            }
            
        } else if occupationField.isHidden == false && introductionField.isHidden == true {
            if occupationField.text?.isEmpty == true {
                print("직업을 입력하세요.")
            } else {
//                statusField.isHidden = false
//                statusLineView.isHidden = false
                statusCounterLabel.isHidden = false
//                statusField.becomeFirstResponder()
                introRectangle.isHidden = false
                introductionField.isHidden = false
                introductionField.becomeFirstResponder()
                dot2View.backgroundColor = CustomColor.nomadGray2
                dot3View.backgroundColor = CustomColor.nomadBlue
                
                index = 2
                updateRequestLabel(index: index)
                requestLabel.asColor(targetString: requestItem[index], color: CustomColor.nomadBlue ?? .label)
            }
            
        } else {
            if let nickname = nicknameField.text, let occupation = occupationField.text, let intro = introductionField.text {
                var isIntroDone = false
                if intro != introPlaceholder && intro.isEmpty == false {
                    isIntroDone = true
                }
                
                if nickname.isEmpty == false && occupation.isEmpty == false && isIntroDone == true {
                    print("입력완료")
                    let user = setUser(nickname: nickname, occupation: occupation, intro: intro)
                    viewModel.user = user
                    Analytics.logEvent("signUpCompleted", parameters: nil)
                    self.dismiss(animated: true) // 마지막 확인 버튼 클릭 후 dismiss 안됨
                } else {
                    showAlert()
                    print("빈칸있음")
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nicknameField {
            nicknameLineView.backgroundColor = CustomColor.nomadBlue
        } else if textField == occupationField {
            occupationLineView.backgroundColor = CustomColor.nomadBlue
        } else {
            statusLineView.backgroundColor = CustomColor.nomadBlue
        }
        
        keyboardAccView.addSubview(inputConfirmButton)
        guard let inputConfirmButtonSuperview = inputConfirmButton.superview else { return }
        inputConfirmButton.anchor(
            top: inputConfirmButtonSuperview.topAnchor,
            left: inputConfirmButtonSuperview.leftAnchor,
            right: inputConfirmButtonSuperview.rightAnchor,
            paddingLeft: 20,
            paddingRight: 20,
            height: 48
        )
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nicknameField {
            nicknameLineView.backgroundColor = CustomColor.nomadGray1
        } else if textField == occupationField {
            occupationLineView.backgroundColor = CustomColor.nomadGray1
        } else {
            statusLineView.backgroundColor = CustomColor.nomadGray1
        }
        
        view.addSubview(inputConfirmButton)
        inputConfirmButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 20, paddingBottom: 33, paddingRight: 20, height: 48)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updateText = currentText.replacingCharacters(in: stringRange, with: string)
        if textField == nicknameField {
            nicknameCounterLabel.text = "\(updateText.count) / \(nicknameLimit)"
            return updateText.count < nicknameLimit
        } else if textField == occupationField {
            occupationCounterLabel.text = "\(updateText.count) / \(occupationLimit)"
            return updateText.count < occupationLimit
        }
//        else if textField == statusField {
//            statusCounterLabel.text = "\(updateText.count) / \(statusLimit)"
//            return updateText.count < statusLimit
//        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didTapInputConfirmButton()
        return true
    }
}

// MARK: - UITextViewDelegate

extension SignUpViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .tertiaryLabel {
            textView.text = nil
            textView.textColor = CustomColor.nomadBlack
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = introPlaceholder
            textView.textColor = .tertiaryLabel
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updateText = currentText.replacingCharacters(in: stringRange, with: text)
        if textView == introductionField {
            statusCounterLabel.text = "\(updateText.count) / \(statusLimit)"
            return updateText.count < statusLimit
        }
        return true
    }
    
}
