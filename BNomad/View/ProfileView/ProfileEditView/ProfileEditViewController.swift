//
//  ProfileEditViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/10/19.
//

import UIKit

class ProfileEditViewController: UIViewController {

    // MARK: - Properties
    
    private lazy var profileImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ProfileDefault"), for: .normal)
        button.addTarget(self, action: #selector(profileImageChange), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 78 / 2
        return button
    }()
    
    let plusImage: UIImageView = {
        let plusImage = UIImageView()
        plusImage.image = UIImage(systemName: "plus.circle.fill")
        plusImage.tintColor = CustomColor.nomadBlue
        return plusImage
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름⋆"
        label.font = .preferredFont(forTextStyle: .title2, weight: .bold)
        label.asColor(targetString: "⋆", color: .systemRed)
        return label
    }()
    
    private let nickNameCounter: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        label.text = "5 / 20"
        return label
    }()
    
    lazy var nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        textField.clearButtonMode = .whileEditing
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.layer.borderColor = CustomColor.nomadGray2?.cgColor
        textField.layer.borderWidth = 1
        textField.text = "윌로우 류"
        textField.delegate = self
        return textField
    }()
    
    private let occupationLabel: UILabel = {
        let label = UILabel()
        label.text = "직책⋆"
        label.font = .preferredFont(forTextStyle: .title2, weight: .bold)
        label.asColor(targetString: "⋆", color: .systemRed)
        return label
    }()
    
    private let occupationCounter: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        label.text = "13/40"
        return label
    }()
    
    private lazy var occupationTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        textField.clearButtonMode = .whileEditing
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.layer.borderColor = CustomColor.nomadGray2?.cgColor
        textField.layer.borderWidth = 1
        textField.delegate = self
        textField.text = "iOS Developer"
        return textField
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "자기소개⋆"
        label.font = .preferredFont(forTextStyle: .title2, weight: .bold)
        label.asColor(targetString: "⋆", color: .systemRed)
        return label
    }()
    
    private let descriptionCounter: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        label.text = "10/50"
        return label
    }()
    
    private lazy var descriprionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.text = "안녕하세요. 반갑습니다."
        textView.layer.cornerRadius = 5
        textView.layer.masksToBounds = true
        textView.layer.borderColor = CustomColor.nomadGray2?.cgColor
        textView.layer.borderWidth = 1
        textView.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        textView.delegate = self
        return textView
    }()
    
    lazy var nicknameStack: UIStackView = {
        let horizontalStack = UIStackView(arrangedSubviews: [nickNameLabel, nickNameCounter])
        horizontalStack.axis = .horizontal
        horizontalStack.isLayoutMarginsRelativeArrangement = true
        horizontalStack.layoutMargins = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        horizontalStack.anchor(width: view.bounds.width - 62)
        horizontalStack.distribution = .fill
        horizontalStack.spacing = 200
        
        let verticalStack = UIStackView(arrangedSubviews: [horizontalStack, nickNameTextField])
        verticalStack.axis = .vertical
        verticalStack.distribution = .fillProportionally
        verticalStack.spacing = 2
        
        return verticalStack
        
    }()
    
    lazy var occupationStack: UIStackView = {
        let horizontalStack = UIStackView(arrangedSubviews: [occupationLabel, occupationCounter])
        horizontalStack.axis = .horizontal
        horizontalStack.isLayoutMarginsRelativeArrangement = true
        horizontalStack.layoutMargins = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        horizontalStack.distribution = .fill
        horizontalStack.spacing = 200
        let verticalStack = UIStackView(arrangedSubviews: [horizontalStack, occupationTextField])
        verticalStack.axis = .vertical
        verticalStack.distribution = .fillProportionally
        verticalStack.spacing = 2
        return verticalStack
    }()
    
    lazy var descriptionStack: UIStackView = {
        let horizontalStack = UIStackView(arrangedSubviews: [descriptionLabel, descriptionCounter])
        horizontalStack.axis = .horizontal
        descriptionCounter.anchor(left: descriptionLabel.rightAnchor, paddingLeft: 100)
        horizontalStack.isLayoutMarginsRelativeArrangement = true
        horizontalStack.layoutMargins = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        horizontalStack.distribution = .fill
        horizontalStack.spacing = 200
        let verticalStack = UIStackView(arrangedSubviews: [horizontalStack, descriprionTextView])
        descriprionTextView.anchor(height: 120)
        verticalStack.axis = .vertical
        verticalStack.distribution = .fillProportionally
        verticalStack.spacing = 2
        return verticalStack
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장하기", for: .normal)
        button.tintColor = .white
        button.backgroundColor = CustomColor.nomadBlue
        button.addTarget(self, action: #selector(saveProfile), for: .touchUpInside)
        button.layer.cornerRadius = 15
        return button
    }()
        
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureProfileImage()
        configureStackView()
        configureSaveButton()
    }
    
    // MARK: - Actions
    
    @objc func profileImageChange() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @objc func saveProfile() {
        // TODO: - 바꾼 profile 최신화함
        let alert = UIAlertController(title: "프로필 수정", message: "프로필 수정을 완료하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "저장", style: .default, handler: { action in
            self.saveEditedProfile { user in
                self.dismiss(animated: true)
            }
        }))
        present(alert, animated: true)
    }
    
    // TODO: - Firebase 프로필 업데이트 로직과 연결할 지점
    private func saveEditedProfile(completion: @escaping(User) -> Void) {
        completion(User(userUid: "userUid", nickname: "nickname"))
    }
    
    // MARK: - Helpers
    
    func configureProfileImage() {
        view.addSubview(profileImageButton)
        profileImageButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 136, paddingLeft: 29, width: 78, height: 78)
        
        view.addSubview(plusImage)
        plusImage.anchor(top: profileImageButton.topAnchor, left: profileImageButton.leftAnchor, paddingTop: 58, paddingLeft: 58, width: 20, height: 20)
    }
    
    func configureStackView() {
        lazy var stack = UIStackView(arrangedSubviews: [nicknameStack, occupationStack, descriptionStack])
        nicknameStack.anchor(height: 80)
        occupationStack.anchor(height: 80)
        descriptionStack.anchor(height: 155)
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 13
        view.addSubview(stack)
        stack.anchor(top: profileImageButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 29, paddingRight: 29)
    }
    
    func configureSaveButton() {
        view.addSubview(saveButton)
        saveButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 29, paddingBottom: 50, paddingRight: 29, height: 58)
    }

}

// MARK: - UITextFieldDelegate

extension ProfileEditViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updateText = currentText.replacingCharacters(in: stringRange, with: string)
        if textField == nickNameTextField {
            nickNameCounter.text = "\(updateText.count) / 20"
            return updateText.count < 20
        } else if textField == occupationTextField {
            occupationCounter.text = "\(updateText.count) / 40"
            return updateText.count < 40
        }
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageButton.setImage(image, for: .normal)
        }
        dismiss(animated: true)
    }
}

// MARK: - UITextViewDelegate
extension ProfileEditViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updateText = currentText.replacingCharacters(in: stringRange, with: text)
        descriptionCounter.text = "\(updateText.count) / 50"
        return updateText.count < 50
    }
}
