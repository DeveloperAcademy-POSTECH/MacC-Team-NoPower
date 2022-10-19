//
//  SignUpViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/10/17.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Properties

    private let requestItem = ["닉네임", "직업", "상태"]
    private var index = 0
    
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
    
    private let statusField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "상태"
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
        dotsStackView.anchor(
            bottom: requestLabel.bottomAnchor,
            right: nicknameField.rightAnchor,
            paddingBottom: 0,
            paddingRight: 0
        )

        nicknameField.delegate = self
        occupationField.delegate = self
        statusField.delegate = self
        
        occupationField.isHidden = true
        occupationLineView.isHidden = true
        statusField.isHidden = true
        statusLineView.isHidden = true
        
        inputConfirmButton.addTarget(self, action: #selector(didTapInputConfirmButton), for: .touchUpInside)
    }
    
    // MARK: - Methods
    
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
        
        view.addSubview(nicknameLineView)
        nicknameLineView.anchor(
            top: nicknameField.bottomAnchor,
            left: requestLabel.leftAnchor,
            paddingTop: textFieldLineSpacing,
            paddingLeft: 0, width: textFieldWidth,
            height: lineHeight
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
        
        keyboardAccView.addSubview(inputConfirmButton)
        
        guard let inputConfirmButtonSuperview = inputConfirmButton.superview
        else {
            return
        }
        
        inputConfirmButton.anchor(
            left: inputConfirmButtonSuperview.leftAnchor,
            right: inputConfirmButtonSuperview.rightAnchor,
            height: inputConfirmButtonSuperview.bounds.height
        )
    }
    
    func updateRequestLabel(index: Int) {
        requestLabel.text = "노마드가 되기 위해\n\(requestItem[index])을 알려주세요!"
    }
    
    // MARK: - Actions
    
    @objc func didTapInputConfirmButton() {

        if occupationField.isHidden == true {
            if nicknameField.text?.isEmpty == true {
                print("닉네임을 입력하세요.")
            } else {
                occupationField.isHidden = false
                occupationLineView.isHidden = false
                dot1View.backgroundColor = CustomColor.nomadGray2
                dot2View.backgroundColor = CustomColor.nomadBlue
                
                index = 1
                updateRequestLabel(index: index)
                requestLabel.asColor(targetString: requestItem[index], color: CustomColor.nomadBlue ?? .label)
            }
            
        } else if occupationField.isHidden == false && statusField.isHidden == true {
            if occupationField.text?.isEmpty == true {
                print("직업을 입력하세요.")
            } else {
                statusField.isHidden = false
                statusLineView.isHidden = false
                dot2View.backgroundColor = CustomColor.nomadGray2
                dot3View.backgroundColor = CustomColor.nomadBlue
                
                index = 2
                updateRequestLabel(index: index)
                requestLabel.asColor(targetString: requestItem[index], color: CustomColor.nomadBlue ?? .label)
            }
            
        } else {
            print("이용자 정보 입력완료")
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
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nicknameField {
            nicknameLineView.backgroundColor = CustomColor.nomadGray1
        } else if textField == occupationField {
            occupationLineView.backgroundColor = CustomColor.nomadGray1
        } else {
            statusLineView.backgroundColor = CustomColor.nomadGray1
        }
    }
}
