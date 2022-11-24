//
//  PlaceRequestViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/11/10.
//

import UIKit

class PlaceRequestViewController: UIViewController {

    // MARK: - Properties
    
    private var keyboardHeight: CGFloat = 0
    private var moveValue: CGFloat = 0
    
    enum Size {
        static let paddingNormal: CGFloat = 20
        static let stackInnerSpacing: CGFloat = 7
    }
    
    let placeName: UILabel = {
        let label = UILabel()
        label.text = "상호명*"
        label.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
        label.asColor(targetString: "*", color: .red)
        return label
    }()
    
    let placeTextField = RequestTextField(placehold: "장소 이름을 입력하세요.")
    
    let placeAddress: UILabel = {
        let label = UILabel()
        label.text = "주소*"
        label.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
        label.asColor(targetString: "*", color: .red)
        return label
    }()
    
    let placeAddressTextField = RequestTextField(placehold: "주소를 입력하세요.")
    
    let recommendReason: UILabel = {
        let label = UILabel()
        label.text = "추천사유"
        label.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
        return label
    }()
    
    lazy var recommendTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = CustomColor.nomadGray3
        textView.layer.cornerRadius = 8
        textView.textContainerInset = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 20)
        textView.font = .preferredFont(forTextStyle: .body, weight: .regular)
        textView.setHeight(150)
        textView.textColor = .tertiaryLabel
        textView.text = "추천 사유를 입력하세요."
        textView.delegate = self
        textView.backgroundColor = CustomColor.nomadGray3
        return textView
    }()
    
    let recommenderContactNumber: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
        label.text = "추천자 연락처"
        return label
    }()
    
    let recommendContactTextField = RequestTextField(placehold: "연락처를 남겨주세요.")
    
    lazy var submit: UIButton = {
        let button = UIButton()
        button.setTitle("제출하기", for: .normal)
        button.tintColor = .white
        button.backgroundColor = CustomColor.nomadBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(sendRequest), for: .touchUpInside)
        return button
    }()
    
    lazy var placeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [placeName, placeTextField])
        stack.axis = .vertical
        stack.spacing = Size.stackInnerSpacing
        stack.alignment = .leading
        stack.distribution = .fill
        
        return stack
    }()

    lazy var addressStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [placeAddress, placeAddressTextField])
        stack.axis = .vertical
        stack.spacing = Size.stackInnerSpacing
        stack.alignment = .leading
        stack.distribution = .fill

        return stack
    }()
    
    lazy var recommendStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [recommendReason, recommendTextView])
        stack.axis = .vertical
        stack.spacing = Size.stackInnerSpacing
        stack.alignment = .leading
        stack.distribution = .fill
        
        return stack
    }()
    
    lazy var contactStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [recommenderContactNumber, recommendContactTextField])
        stack.axis = .vertical
        stack.spacing = Size.stackInnerSpacing
        stack.alignment = .leading
        stack.distribution = .fill
        
        return stack
    }()

    lazy var wholeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [placeStack, addressStack, recommendStack, contactStack])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 28
        
        return stack
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "새로운 노마드스팟"
        hideKeyboardWhenTappedAround()
        setKeyboardObserver()
        recommendContactTextField.delegate = self
    }
    
    // MARK: - Actions
    
    @objc func sendRequest() {
        // TODO: 장소 제안 보내는 로직, 상호명과 주소가 nil값이 아님을 체크해주어야 한다.
        guard let placeName = placeTextField.text else { return }
        guard let placeAddress = placeAddressTextField.text else { return }
        if placeName == "" || placeAddress == "" {
            let alert = UIAlertController(title: "장소 제출 오류", message: "상호명 혹은 주소란에 빈칸이 있습니다.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "확인", style: .cancel)
            alert.addAction(cancel)
            present(alert, animated: true)
        }
        FirebaseManager.shared.suggestPlace(placeName: placeName, placeAddress: placeAddress, recommendReason: recommendTextView.text, recommenderContactNumber: recommendContactTextField.text)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification)  {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
        print("keyboardWillShow")
    }
    
    // MARK: - Helpers
    
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func configUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(wholeStack)
        wholeStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: Size.paddingNormal, paddingLeft: Size.paddingNormal, paddingRight: Size.paddingNormal)
        placeTextField.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: Size.paddingNormal, paddingRight: Size.paddingNormal)
        placeAddressTextField.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: Size.paddingNormal, paddingRight: Size.paddingNormal)
        recommendTextView.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: Size.paddingNormal, paddingRight: Size.paddingNormal)
        recommendContactTextField.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: Size.paddingNormal, paddingRight: Size.paddingNormal)
        
        view.addSubview(submit)
        submit.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: Size.paddingNormal, paddingBottom: 50, paddingRight: Size.paddingNormal, height: 50)
    }
}

// MARK: - UITextViewDelegate

extension PlaceRequestViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
        if textField == recommendContactTextField {
            let screenHeight = UIScreen.main.bounds.height
            let keyboardY = screenHeight - keyboardHeight
            let contentY = wholeStack.frame.minY + wholeStack.frame.height

            guard let window = UIApplication.shared.windows.first else { return }
            let topSafeAreaHeight = window.safeAreaInsets.top
            print("키보드높이: \(keyboardHeight), 내용Y: \(contentY), TopSafeArea: \(topSafeAreaHeight)")
            
            if contentY > keyboardY {
                moveValue = contentY - keyboardY + topSafeAreaHeight
                UIView.animate(withDuration: 0.2) {
                    self.view.window?.frame.origin.y -= self.moveValue
                }
            } else {
                moveValue = 0
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == recommendContactTextField {
            UIView.animate(withDuration: 0.2) {
                self.view.window?.frame.origin.y += self.moveValue
            }
        }
    }
}

extension PlaceRequestViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .tertiaryLabel {
            textView.text = nil
            textView.textColor = CustomColor.nomadBlack
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "추천 사유를 입력하세요."
            textView.textColor = .tertiaryLabel
        }
    }
}
