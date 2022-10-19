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
        return button
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.font = .preferredFont(forTextStyle: .title2, weight: .bold)
        return label
    }()
    
    private let nickNameCounter: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        label.text = "5 / 20"
        return label
    }()
    
    private let nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        textField.clearButtonMode = .whileEditing
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.layer.borderColor = CustomColor.nomadGray2?.cgColor
        textField.layer.borderWidth = 1
        textField.text = "윌로우 류"
        return textField
    }()
    
    private let occupationLabel: UILabel = {
        let label = UILabel()
        label.text = "직책"
        label.font = .preferredFont(forTextStyle: .title2, weight: .bold)
        return label
    }()
    
    private let occupationCounter: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        label.text = "13/40"
        return label
    }()
    
    private let occupationTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        textField.clearButtonMode = .whileEditing
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.layer.borderColor = CustomColor.nomadGray2?.cgColor
        textField.layer.borderWidth = 1
        textField.text = "iOS Developer"
        return textField
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "자기소개"
        label.font = .preferredFont(forTextStyle: .title2, weight: .bold)
        return label
    }()
    
    private let descriptionCounter: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        label.text = "10/50"
        return label
    }()
    
    private let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        textField.clearButtonMode = .whileEditing
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.layer.borderColor = CustomColor.nomadGray2?.cgColor
        textField.layer.borderWidth = 1
        textField.text = "안녕하세요. 반갑습니다."
        return textField
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
        horizontalStack.isLayoutMarginsRelativeArrangement = true
        horizontalStack.layoutMargins = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        horizontalStack.distribution = .fill
        horizontalStack.spacing = 200
        let verticalStack = UIStackView(arrangedSubviews: [horizontalStack, descriptionTextField])
        descriptionTextField.anchor(height: 120)
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
        return button
    }()
        
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureProfileImage()
        configureStackView()
    }
    
    // MARK: - Actions
    
    @objc func profileImageChange() {
        // TODO: - UIImagePicker 가져와야함
    }
    
    @objc func saveProfile() {
        // TODO: - 바꾼 profile 최신화함
    }
    
    // MARK: - Helpers
    
    func configureProfileImage() {
        view.addSubview(profileImageButton)
        profileImageButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 136, paddingLeft: 29, width: 78, height: 78)
        
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

}
