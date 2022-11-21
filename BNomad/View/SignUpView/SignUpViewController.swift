//
//  SignUpViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/10/17.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var viewModel: CombineViewModel = CombineViewModel.shared
    
    var userIdentifier: String = ""
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(CustomColor.nomadGray1, for: .normal)
        button.addTarget(self, action: #selector(didTapCancelButon), for: .touchUpInside)
// A/B 테스트 시 사용예정
//        if RCValue.shared.bool(forKey: ValueKey.isLoginFirst) {
//            button.isHidden = true
//        }
        return button
    }()

    private let requestItem = ["닉네임", "직업", "상태", "멋진 사진"]
    private lazy var requestSentence = ["\(requestItem[0])을 알려주세요!", "\(requestItem[1])을 알려주세요!", "\(requestItem[2])를 알려주세요!", "\(requestItem[3])을 올려주세요!"]
    private var index = 0
    private let nicknameLimit = 20
    private let occupationLimit = 40
    private let statusLimit = 150
    private let introPlaceholder = "자기소개를 작성해주세요!"
    
    private var keyboardHeight: CGFloat = 0
    private var moveValue: CGFloat = 0

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
    
    lazy var dot4View: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        view.backgroundColor = CustomColor.nomadGray2
        view.layer.cornerRadius = 2.5
        view.contentMode = .scaleAspectFit

        return view
    }()
    
    lazy var dotsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dot1View, dot2View, dot3View, dot4View])
        stackView.axis = .horizontal
        stackView.spacing = 8.0
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        stackView.backgroundColor = .clear

        dot1View.anchor(width: 5, height: 5)
        dot2View.anchor(width: 5, height: 5)
        dot3View.anchor(width: 5, height: 5)
        dot4View.anchor(width: 5, height: 5)

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
        view.layer.borderColor = CustomColor.nomadGray1?.cgColor
        
        return view
    }()
    
    private lazy var statusCounterLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        label.text = "0 / \(statusLimit)"
        label.textColor = CustomColor.nomadGray1
        
        return label
    }()
    
    private lazy var profileImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person.circle.fill"), for: .normal)
        button.tintColor = CustomColor.nomadGray2
        button.addTarget(self, action: #selector(didTapProfileImageButton), for: .touchUpInside)
        button.layer.masksToBounds = true
        
        return button
    }()
    
    private let plusView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "plus.circle.fill")
        view.tintColor = CustomColor.nomadBlue
        
        return view
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

        return view
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        Analytics.logEvent("signUpViewLoaded", parameters: [
//            AnalyticsParameterItemName: "signUpViewLoaded",
//          ])

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
        statusCounterLabel.isHidden = true
        introRectangle.isHidden = true
        introductionField.isHidden = true
        profileImageButton.isHidden = true
        plusView.isHidden = true
        
        inputConfirmButton.addTarget(self, action: #selector(didTapInputConfirmButton), for: .touchUpInside)
        
        hideKeyboardWhenTappedAround()
        configCancelButton()
        
        setKeyboardObserver()
    }
    
    // MARK: - Methods
    
    func setUser(nickname: String, occupation: String, intro: String) -> User? {
        let user = User(userUid: userIdentifier, nickname: nickname, occupation: occupation, introduction: intro)
        FirebaseManager.shared.setUser(user: user)
        return user
    }
    
    func configUI() {
        let viewWidth = view.bounds.width
        let viewHeight = view.bounds.height
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
        
        let profileImageSize = viewWidth * 150/390
        let plusImageSize = profileImageSize * 36/127
        let profileImagePaddingTop = viewHeight * 140/844
        
        view.addSubview(profileImageButton)
        profileImageButton.setPreferredSymbolConfiguration(.init(pointSize: profileImageSize, weight: .regular, scale: .default), forImageIn: .normal)
        profileImageButton.layer.cornerRadius = profileImageSize / 2
        profileImageButton.centerX(inView: view)
        profileImageButton.anchor(
            top: requestLabel.bottomAnchor,
            paddingTop: profileImagePaddingTop,
            width: profileImageSize,
            height: profileImageSize
        )
        
        view.addSubview(plusView)
        plusView.anchor(
            bottom: profileImageButton.bottomAnchor,
            right: profileImageButton.rightAnchor,
            paddingBottom: 10,
            paddingRight: 5,
            width: plusImageSize,
            height: plusImageSize
        )
    }
    
    func updateRequestLabel(index: Int) {
        requestLabel.text = "노마드가 되기 위해\n\(requestSentence[index])"
    }
    
    func showAlert(message: String) {
        let alertLabel = UILabel()
        alertLabel.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        alertLabel.text = message
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
            bottom: requestLabel.topAnchor,
            right: view.rightAnchor,
            paddingRight: 20
        )
    }
    
    func showKeyboardAcc() {
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
    
    func showInputConfirmButton() {
        view.addSubview(inputConfirmButton)
        inputConfirmButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 20, paddingBottom: 33, paddingRight: 20, height: 48)
    }
    
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // MARK: - Actions
    
    @objc func keyboardWillShow(notification: NSNotification)  {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
    }
    
    @objc func didTapCancelButon() {
        let cancelAlert = UIAlertController(title: "취소하시겠습니까?", message: "취소하면 작성한 내용이 저장되지 않습니다.", preferredStyle: .alert)
        cancelAlert.addAction(UIAlertAction(title: "작성 취소", style: .default, handler: { action in
            self.dismiss(animated: true)
        }))
        cancelAlert.addAction(UIAlertAction(title: "계속 작성", style: .cancel))
        present(cancelAlert, animated: true)
    }
    
    @objc func didTapProfileImageButton() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    // TODO: - 입력된 user 정보 기반을 user 생성 & firebase에 user 정보 업데이트
    @objc func didTapInputConfirmButton() {
        
        // 닉네임 입력 중일 때
        if occupationField.isHidden == true && profileImageButton.isHidden == true {
            
            // 닉네임 빈칸
            if nicknameField.text?.isEmpty == true {
                showAlert(message: "닉네임을 입력해주세요!")
                
            // 닉네임 빈칸 아님 -> 직업칸 보여줌
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
            
        // 직업 입력 중일 때
        } else if occupationField.isHidden == false && introductionField.isHidden == true {
            
            // 직업칸 빈칸
            if occupationField.text?.isEmpty == true {
                showAlert(message: "직업을 입력해주세요!")
                
            // 직업칸 빈칸 아님 -> 자기소개칸 보여줌
            } else {
                statusCounterLabel.isHidden = false
                introRectangle.isHidden = false
                introductionField.isHidden = false
                introductionField.becomeFirstResponder()
                dot2View.backgroundColor = CustomColor.nomadGray2
                dot3View.backgroundColor = CustomColor.nomadBlue
                
                index = 2
                updateRequestLabel(index: index)
                requestLabel.asColor(targetString: requestItem[index], color: CustomColor.nomadBlue ?? .label)
            }
        
        // 자기소개 입력 중일 때
        } else if introductionField.isHidden == false && profileImageButton.isHidden == true {
            if let nickname = nicknameField.text, let occupation = occupationField.text, let intro = introductionField.text {
                var isIntroDone = false
                if intro != introPlaceholder && intro.isEmpty == false {
                    isIntroDone = true
                }
                
                // 닉네임, 직업, 자기소개 모두 입력된 경우 -> 프로필사진 업로드화면으로 넘어감
                if !nickname.isEmpty && !occupation.isEmpty && isIntroDone == true {
                    nicknameField.isHidden = true
                    nicknameLineView.isHidden = true
                    nicknameCounterLabel.isHidden = true
                    occupationField.isHidden = true
                    occupationLineView.isHidden = true
                    occupationCounterLabel.isHidden = true
                    statusCounterLabel.isHidden = true
                    introRectangle.isHidden = true
                    introductionField.isHidden = true
                    
                    profileImageButton.isHidden = false
                    plusView.isHidden = false
                    dot3View.backgroundColor = CustomColor.nomadGray2
                    dot4View.backgroundColor = CustomColor.nomadBlue
                    inputConfirmButton.setTitle("확인", for: .normal)
                    index = 3
                    updateRequestLabel(index: index)
                    requestLabel.asColor(targetString: requestItem[index], color: CustomColor.nomadBlue ?? .label)
                    view.endEditing(true)
                
                // 닉네임, 직업, 자기소개 중 빈칸 있는 경우 -> 경고 메시지
                } else {
                    showAlert(message: "빈칸없이 입력해주세요!")
                }
            }
        
        // 사진 업로드 화면일 때 -> 드디어 저장(사진 업로드 여부 체크 X)
        } else if profileImageButton.isHidden == false {
            if let nickname = nicknameField.text, let occupation = occupationField.text, let intro = introductionField.text, let image = profileImageButton.image(for: .normal) {
            
                FirebaseManager.shared.uploadUserProfileImage(userUid: userIdentifier, image: image) {[self] url in
                    viewModel.user?.profileImageUrl = url
                    let user = User(userUid: userIdentifier, nickname: nickname, occupation: occupation, introduction: intro, profileImageUrl: url)
                    viewModel.user = user
                    FirebaseManager.shared.setUser(user: user)
                }
                
//                Analytics.logEvent("signUpCompleted", parameters: nil)
                
                let completedAlert = UIAlertController(title: "회원가입 완료", message: "회원가입이 완료되었습니다.", preferredStyle: .alert)
                completedAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
                    self.dismiss(animated: true)
                }))
                present(completedAlert, animated: true)
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
        }
        
        showKeyboardAcc()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nicknameField {
            nicknameLineView.backgroundColor = CustomColor.nomadGray1
        } else if textField == occupationField {
            occupationLineView.backgroundColor = CustomColor.nomadGray1
        }
        showInputConfirmButton()
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
        introRectangle.layer.borderColor = CustomColor.nomadBlue?.cgColor
        showKeyboardAcc()
        
        let screenHeight = UIScreen.main.bounds.height
        let keyboardAndAccHeight = keyboardHeight + self.keyboardAccView.frame.height
        let keyboardAndAccY = screenHeight - keyboardAndAccHeight
        let introY = statusCounterLabel.frame.minY + statusCounterLabel.frame.height
        
        if introY > keyboardAndAccY {
            moveValue = introY - keyboardAndAccY
            UIView.animate(withDuration: 0.2) {
                self.view.window?.frame.origin.y -= self.moveValue
            }
        } else {
            moveValue = 0
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = introPlaceholder
            textView.textColor = .tertiaryLabel
        }
        introRectangle.layer.borderColor = CustomColor.nomadGray1?.cgColor
        showInputConfirmButton()
        
        UIView.animate(withDuration: 0.2) {
            self.view.window?.frame.origin.y += self.moveValue
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

// MARK: - UIImagePickerControllerDelegate

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageButton.setImage(image, for: .normal)
        }
        dismiss(animated: true)
    }
    
}
