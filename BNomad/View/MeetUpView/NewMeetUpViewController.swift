//
//  NewMeetUpViewController.swift
//  BNomad
//
//  Created by Eunbee Kang on 2022/11/07.
//

import UIKit

class NewMeetUpViewController: UIViewController {

    // MARK: - Properties
    
    private let subject: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = CustomColor.nomadBlack
        
        return label
    }()
    
    private let subjectRectangle: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.nomadGray3
        view.layer.cornerRadius = 12
        
        return view
    }()
    
    private let time: UILabel = {
        let label = UILabel()
        label.text = "모임 시간"
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = CustomColor.nomadBlack
        
        return label
    }()
    
    private let timeRectangle: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.nomadGray3
        view.layer.cornerRadius = 12
        
        return view
    }()
    
    private let location: UILabel = {
        let label = UILabel()
        label.text = "모임 장소"
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = CustomColor.nomadBlack
        
        return label
    }()
    
    private let locationRectangle: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.nomadGray3
        view.layer.cornerRadius = 12
        
        return view
    }()
    
    private let people: UILabel = {
        let label = UILabel()
        label.text = "모집 인원(나 포함)"
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = CustomColor.nomadBlack
        
        return label
    }()
    
    private let peopleRectangle: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.nomadGray3
        view.layer.cornerRadius = 12
        
        return view
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = CustomColor.nomadBlack
        button.backgroundColor = .white
        
        return button
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.nomadGray2
        view.anchor(width: 1, height: 36)
        
        return view
    }()
    
    private let minusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.tintColor = CustomColor.nomadBlack
        button.backgroundColor = .white
        
        return button
    }()
    
    lazy var peopleCounterView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [plusButton, divider, minusButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 1
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 12
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = CustomColor.nomadGray2?.cgColor
        stackView.layer.shadowRadius = 5
        stackView.layer.shadowOpacity = 0.05
        stackView.layer.shadowColor = CustomColor.nomadBlack?.cgColor
        stackView.layer.shadowOffset = CGSize(width: 3, height: 4)
        
        return stackView
    }()
    
    private let content: UILabel = {
        let label = UILabel()
        label.text = "내용"
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = CustomColor.nomadBlack
        
        return label
    }()
    
    private let contentRectangle: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.nomadGray3
        view.layer.cornerRadius = 12
        
        return view
    }()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        
        navigationItem.title = "새로운 모임 생성"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTapDoneCreatingMeetUp))
                 navigationController?.navigationBar.tintColor = CustomColor.nomadBlue
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didTapCancelCreatingMeetUp))
    }
    
    // MARK: - Actions
    
    @objc func didTapDoneCreatingMeetUp() {
        // TODO: 내용 저장
    }
    
    @objc func didTapCancelCreatingMeetUp() {
        // TODO: dismiss 동작
    }
    
    // MARK: - Helpers
    
    func configUI() {
        
        view.backgroundColor = .white
        
        let viewHeight = view.bounds.height
        let paddingTop = viewHeight * 100/844
        
        view.addSubview(subject)
        subject.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: paddingTop, paddingLeft: 20)
        
        view.addSubview(subjectRectangle)
        subjectRectangle.anchor(top: subject.bottomAnchor, left: subject.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingRight: 20, height: 48)
        
        view.addSubview(time)
        time.anchor(top: subjectRectangle.bottomAnchor, left: subject.leftAnchor, paddingTop: 30)
        
        view.addSubview(timeRectangle)
        timeRectangle.anchor(top: time.bottomAnchor, left: subject.leftAnchor, right: subjectRectangle.rightAnchor, paddingTop: 8, height: 48)
        
        view.addSubview(location)
        location.anchor(top: timeRectangle.bottomAnchor, left: subject.leftAnchor, paddingTop: 30)
        
        view.addSubview(locationRectangle)
        locationRectangle.anchor(top: location.bottomAnchor, left: subject.leftAnchor, right: subjectRectangle.rightAnchor, paddingTop: 8, height: 48)
        
        view.addSubview(people)
        people.anchor(top: locationRectangle.bottomAnchor, left: subject.leftAnchor, paddingTop: 30)
        
        let viewWidth = view.bounds.width
        let halfRectWidth = (viewWidth - 20*2 - 10*2)/2
        
        view.addSubview(peopleRectangle)
        peopleRectangle.anchor(top: people.bottomAnchor, left: subject.leftAnchor, paddingTop: 8, width: halfRectWidth, height: 48)
        
        view.addSubview(peopleCounterView)
        peopleCounterView.anchor(top: peopleRectangle.topAnchor, right: view.rightAnchor, paddingRight: 20, width: halfRectWidth, height: 48)
        
        view.addSubview(content)
        content.anchor(top: peopleRectangle.bottomAnchor, left: subject.leftAnchor, paddingTop: 30)
        
        view.addSubview(contentRectangle)
        contentRectangle.anchor(top: content.bottomAnchor, left: subject.leftAnchor, right: subjectRectangle.rightAnchor, paddingTop: 8, height: 120)
        
    }
}
