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
    
    private let subjectField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "모임 제목을 입력하세요."
        textField.font = .preferredFont(forTextStyle: .body)
        textField.borderStyle = .none
        textField.clearButtonMode = .whileEditing
        
        return textField
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
    
    private let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.frame.size = CGSize(width: 0, height: 250)
        picker.locale = Locale(identifier: "ko_KR")
        picker.addTarget(self, action: #selector(didTimePickerValueChange), for: .valueChanged)
        
        return picker
    }()
    
    private let timePickerToolBar: UIToolbar = {
        let toolBar = UIToolbar()
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didTapCancelTimePicker))
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTapDoneTimePicker))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        cancelButton.tintColor = CustomColor.nomadBlue
        doneButton.tintColor = CustomColor.nomadBlue
        
        toolBar.sizeToFit()
        toolBar.setItems([cancelButton, space, doneButton], animated: false)
        
        return toolBar
    }()
    
    private let timeField: UITextField = {
        let textField = UITextField()
        textField.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        textField.borderStyle = .none
        
        return textField
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
    
    private let locationField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "모임 장소를 입력하세요."
        textField.font = .preferredFont(forTextStyle: .body)
        textField.borderStyle = .none
        textField.clearButtonMode = .whileEditing
        
        return textField
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
    
    @objc func didTimePickerValueChange() {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        self.timeField.text = formatter.string(from: timePicker.date)
    }
    
    @objc func didTapCancelTimePicker() {
        timeField.resignFirstResponder()
    }
    
    @objc func didTapDoneTimePicker() {
        timeField.resignFirstResponder()
    }
    
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
        
        subjectRectangle.addSubview(subjectField)
        subjectField.centerY(inView: subjectRectangle)
        subjectField.anchor(left: subjectRectangle.leftAnchor, right: subjectRectangle.rightAnchor, paddingLeft: 20, paddingRight: 10)
        
        view.addSubview(time)
        time.anchor(top: subjectRectangle.bottomAnchor, left: subject.leftAnchor, paddingTop: 30)
        
        view.addSubview(timeRectangle)
        timeRectangle.anchor(top: time.bottomAnchor, left: subject.leftAnchor, right: subjectRectangle.rightAnchor, paddingTop: 8, height: 48)
        
        timeRectangle.addSubview(timeField)
        timeField.center(inView: timeRectangle)
        timeField.inputView = timePicker
        timeField.inputAccessoryView = timePickerToolBar
        
        view.addSubview(location)
        location.anchor(top: timeRectangle.bottomAnchor, left: subject.leftAnchor, paddingTop: 30)
        
        view.addSubview(locationRectangle)
        locationRectangle.anchor(top: location.bottomAnchor, left: subject.leftAnchor, right: subjectRectangle.rightAnchor, paddingTop: 8, height: 48)
        
        locationRectangle.addSubview(locationField)
        locationField.centerY(inView: locationRectangle)
        locationField.anchor(left: subjectRectangle.leftAnchor, right: subjectRectangle.rightAnchor, paddingLeft: 20, paddingRight: 10)
        
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
