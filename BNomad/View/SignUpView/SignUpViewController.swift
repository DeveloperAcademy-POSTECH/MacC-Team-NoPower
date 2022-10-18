//
//  SignUpViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/10/17.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Properties

    let requestItem = ["닉네임", "직업", "상태"]
    
    private let requestLabel: UILabel = {
        let label = UILabel()
        label.text = "노마드가 되기 위해\n닉네임을 알려주세요!"
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
    
    private let nicknameLineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.nomadGray1
        return view
    }()
    
    private let occupationField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "직업"
        textfield.font = .preferredFont(forTextStyle: .title3)
        textfield.borderStyle = .none
        textfield.clearButtonMode = .whileEditing
        return textfield
    }()
    
    private let occupationLineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.nomadGray1
        return view
    }()
    
    private let statusField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "상태"
        textfield.font = .preferredFont(forTextStyle: .title3)
        textfield.borderStyle = .none
        textfield.clearButtonMode = .whileEditing
        return textfield
    }()
    
    private let statusLineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.nomadGray1
        return view
    }()
    
    private let inputConfirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body, weight: .semibold)
        button.backgroundColor = CustomColor.nomadBlue
        
        return button
    }()
    
    private var keyboardAccView: UIView = {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 56.0))
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
        view.addSubview(dotsStackView)
        dotsStackView.anchor(bottom: requestLabel.bottomAnchor, right: nicknameField.rightAnchor, paddingBottom: 0, paddingRight: 0)
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
        requestLabel.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 87, paddingLeft: contentInset)
        requestLabel.asColor(targetString: "닉네임", color: CustomColor.nomadBlue ?? .label)

        view.addSubview(nicknameField)
        nicknameField.inputAccessoryView = keyboardAccView
        nicknameField.anchor(
            top: requestLabel.bottomAnchor,
            left: requestLabel.leftAnchor,
            paddingTop: 64,
            paddingLeft: 0,
            width: textFieldWidth
        )
        
        view.addSubview(nicknameLineView)
        nicknameLineView.anchor(top: nicknameField.bottomAnchor, left: requestLabel.leftAnchor, paddingTop: textFieldLineSpacing, paddingLeft: 0, width: textFieldWidth, height: lineHeight)
        
        view.addSubview(occupationField)
        occupationField.anchor(top: nicknameField.bottomAnchor, left: requestLabel.leftAnchor, paddingTop: textFieldTopSpacing, paddingLeft: 0, width: textFieldWidth)
        
        view.addSubview(occupationLineView)
        occupationLineView.anchor(top: occupationField.bottomAnchor, left: requestLabel.leftAnchor, paddingTop: textFieldLineSpacing, paddingLeft: 0, width: textFieldWidth, height: lineHeight)
        
        view.addSubview(statusField)
        statusField.anchor(top: occupationField.bottomAnchor, left: requestLabel.leftAnchor, paddingTop: textFieldTopSpacing, paddingLeft: 0, width: textFieldWidth)
        
        view.addSubview(statusLineView)
        statusLineView.anchor(top: statusField.bottomAnchor, left: requestLabel.leftAnchor, paddingTop: textFieldLineSpacing, paddingLeft: 0, width: textFieldWidth, height: lineHeight)
        
        keyboardAccView.addSubview(inputConfirmButton)
        
        guard let inputConfirmButtonSuperview = inputConfirmButton.superview
        else {
            return
        }
        
        inputConfirmButton.anchor(
            left: inputConfirmButtonSuperview.leftAnchor,
            right: inputConfirmButtonSuperview.rightAnchor,
            width: inputConfirmButtonSuperview.bounds.width,
            height: inputConfirmButtonSuperview.bounds.height
        )
    }
}
