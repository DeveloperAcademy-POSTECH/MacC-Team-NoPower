//
//  WithdrawViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/11/10.
//

import UIKit

class WithdrawViewController: UIViewController {

    // MARK: - Properties
    
    enum Size {
        static let paddingNormal: CGFloat = 20
    }
    
    private let withdrawLabel: UILabel = {
        let label = UILabel()
        label.text = "탈퇴 사유"
        label.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
        return label
    }()
    
    lazy var reasonTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = CustomColor.nomadGray3
        textView.delegate = self
        textView.layer.cornerRadius = 12
        textView.text = "탈퇴사유를 입력하세요."
        textView.textColor = .tertiaryLabel
        textView.textContainerInset = UIEdgeInsets(top: 13, left: Size.paddingNormal, bottom: 13, right: Size.paddingNormal)
        textView.font = .preferredFont(forTextStyle: .body, weight: .regular)
        return textView
    }()
    
    private lazy var withdrawButton: UIButton = {
        let button = UIButton()
        button.setTitle("탈퇴하기", for: .normal)
        button.tintColor = .white
        button.backgroundColor = CustomColor.nomadBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(withdraw), for: .touchUpInside)
        return button
    }()
        
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "회원 탈퇴"
        navigationController?.navigationBar.prefersLargeTitles = false
        configUI()
    }
    
    // MARK: - Actions
    
    @objc func withdraw() {
        let alert = UIAlertController(title: "탈퇴하기", message: "탈퇴하시겠습니까?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let withdrawConfirm = UIAlertAction(title: "탈퇴", style: .destructive) { action in
            // TODO: 유저를 지우는 액션이 들어가 있어야 합니다.
            print("탈퇴합니다")
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(cancel)
        alert.addAction(withdrawConfirm)
        self.present(alert, animated: true)
    }
    
    // MARK: - Helpers
    
    func configUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(withdrawLabel)
        withdrawLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: Size.paddingNormal, paddingLeft: Size.paddingNormal)
        
        view.addSubview(reasonTextView)
        reasonTextView.anchor(top: withdrawLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: Size.paddingNormal, paddingRight: Size.paddingNormal, height: 178)
        
        view.addSubview(withdrawButton)
        withdrawButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: Size.paddingNormal, paddingBottom: 50, paddingRight: Size.paddingNormal, height: 50)
        
    }

}

// MARK: - UITextViewDelegate

extension WithdrawViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .tertiaryLabel {
            textView.text = nil
            textView.textColor = CustomColor.nomadBlack
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "탈퇴사유를 입력하세요."
            textView.textColor = .tertiaryLabel
        }
    }
}
