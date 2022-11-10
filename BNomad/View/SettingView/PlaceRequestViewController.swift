//
//  PlaceRequestViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/11/10.
//

import UIKit

class PlaceRequestViewController: UIViewController {

    // MARK: - Properties
    
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
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 20)
        textView.font = .preferredFont(forTextStyle: .body, weight: .regular)
        textView.setHeight(150)
        textView.textColor = .tertiaryLabel
        textView.text = "추천 사유를 입력하세요."
        textView.delegate = self
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
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "장소 제보"
    }
    
    // MARK: - Actions
    
    @objc func sendRequest() {
        // TODO: 장소 제안 보내는 로직, 상호명과 주소가 nil값이 아님을 체크해주어야 한다.
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    
    private func configUI() {
        view.backgroundColor = .systemBackground
        
        let placeStack = UIStackView(arrangedSubviews: [placeName, placeTextField])
        placeStack.axis = .vertical
        placeStack.spacing = Size.stackInnerSpacing
        placeStack.alignment = .leading
        placeStack.distribution = .fill
        
        let addressStack = UIStackView(arrangedSubviews: [placeAddress, placeAddressTextField])
        addressStack.axis = .vertical
        addressStack.spacing = Size.stackInnerSpacing
        addressStack.alignment = .leading
        addressStack.distribution = .fill
        
        let recommendStack = UIStackView(arrangedSubviews: [recommendReason, recommendTextView])
        recommendStack.axis = .vertical
        recommendStack.spacing = Size.stackInnerSpacing
        recommendStack.alignment = .leading
        recommendStack.distribution = .fill
        
        let contactStack = UIStackView(arrangedSubviews: [recommenderContactNumber, recommendContactTextField])
        contactStack.axis = .vertical
        contactStack.spacing = Size.stackInnerSpacing
        contactStack.alignment = .leading
        contactStack.distribution = .fill
        
        let stack = UIStackView(arrangedSubviews: [placeStack, addressStack, recommendStack, contactStack])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 28
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: Size.paddingNormal, paddingLeft: Size.paddingNormal, paddingRight: Size.paddingNormal)
        placeTextField.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: Size.paddingNormal, paddingRight: Size.paddingNormal)
        placeAddressTextField.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: Size.paddingNormal, paddingRight: Size.paddingNormal)
        recommendTextView.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: Size.paddingNormal, paddingRight: Size.paddingNormal)
        recommendContactTextField.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: Size.paddingNormal, paddingRight: Size.paddingNormal)
        
        view.addSubview(submit)
        submit.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: Size.paddingNormal, paddingBottom: 50, paddingRight: Size.paddingNormal, height: 50)
    }
    
}

// MARK: - UITextViewDelegate

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
