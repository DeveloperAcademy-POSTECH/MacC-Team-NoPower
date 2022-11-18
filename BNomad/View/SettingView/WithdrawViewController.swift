//
//  WithdrawViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/11/10.
//

import UIKit
import FirebaseAuth

class WithdrawViewController: UIViewController {

    // MARK: - Properties
    
    enum Size {
        static let paddingNormal: CGFloat = 20
    }
    var viewModel = CombineViewModel.shared
    
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
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Actions
    
    @objc func withdraw() {
        let alert = UIAlertController(title: "탈퇴하기", message: "지금까지의 체크인, 밋업 기록이 삭제됩니다.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let withdrawConfirm = UIAlertAction(title: "탈퇴", style: .destructive) { action in
            if Auth.auth().currentUser != nil {
                Auth.auth().currentUser?.delete()
                do {
                    try Auth.auth().signOut()
                    if self.viewModel.user?.currentCheckIn == nil {
                        self.viewModel.user = nil
                    } else {
                        guard let current = self.viewModel.user?.currentCheckIn else { return }
                        let userUid = self.viewModel.user?.userUid
                        FirebaseManager.shared.setCheckOut(checkIn: current) { checkIn in
                            let index = self.viewModel.user?.checkInHistory?.firstIndex { $0.checkInUid == checkIn.checkInUid }
                            guard let index = index else {
                                print("fail index")
                                return
                            }
                            self.viewModel.user?.checkInHistory?[index] = checkIn
                            self.viewModel.user = nil
                            FirebaseManager.shared.uploadUserWithdrawalReason(userUid: userUid ?? "", reason: self.reasonTextView.text) {
                                FirebaseManager.shared.fetchMeetUpUidAll(userUid: userUid ?? "") { uid in
                                    FirebaseManager.shared.getPlaceUidWithMeetUpId(meetUpUid: uid) { placeUid in
                                        FirebaseManager.shared.cancelMeetUp(userUid: userUid ?? "", meetUpUid: uid, placeUid: placeUid) {
                                        }
                                    }
                                }
                            }
                        }
                    }
                    self.navigationController?.popToRootViewController(animated: true)
                } catch {
                    print("SignOut ERROR")
                }
            } else {
                self.noUserAlert()
            }
        }
        alert.addAction(cancel)
        alert.addAction(withdrawConfirm)
        self.present(alert, animated: true)
    }
    
    func noUserAlert() {
        let alert = UIAlertController(title: "탈퇴 오류", message: "로그인 되어 있지 않습니다.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "확인", style: .default)
        alert.addAction(cancel)
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
