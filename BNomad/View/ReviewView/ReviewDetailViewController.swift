//
//  ReviewDetailViewController.swift
//  BNomad
//
//  Created by 박진웅 on 2022/11/09.
//

import UIKit
import AVFoundation
import FirebaseAuth

class ReviewDetailViewController: UIViewController {
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        var config = UIImage.SymbolConfiguration(pointSize: 12)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        button.layer.cornerRadius = 15
        button.tintColor = UIColor(hex: "3C3C43")?.withAlphaComponent(0.6)
        button.backgroundColor = UIColor(hex: "F2F2F7")
        button.addTarget(self, action: #selector(dismissPage), for: .touchUpInside)
        return button
    }()
    
    var place: Place? {
        didSet {
            placeName.text = place?.name
        }
    }
    
    let placeName: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        title.textColor = .black
        title.font = .preferredFont(forTextStyle: .title1, weight: .bold)
        title.textAlignment = .center
        return title
    }()
    
    private let shareExperienceText: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        title.textColor = .black
        title.font = .preferredFont(forTextStyle: .title1, weight: .bold)
        title.text = "경험을 공유해주세요."
        title.textAlignment = .center
        return title
    }()
    
    lazy var reviewTextView: UITextView = {
        let textview = UITextView()
        textview.font = .preferredFont(forTextStyle: .body, weight: .regular)
        textview.textColor = .black
        textview.layer.borderWidth = 1
        textview.layer.borderColor = CustomColor.nomadBlue?.cgColor
        textview.layer.cornerRadius = 8
        textview.textContainerInset = .init(top: 14, left: 14, bottom: 14, right: 14)
        textview.scrollIndicatorInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        textview.text = "리뷰를 입력해주세요."
        textview.textColor = CustomColor.nomadGray1
        textview.delegate = self
        return textview
    }()
    
    private let addPhotoText: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        title.textColor = .black
        title.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        title.text = "사진 첨부"
        title.textAlignment = .center
        return title
    }()
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton()
        var config = UIImage.SymbolConfiguration(pointSize: 32)
        button.setImage(UIImage(systemName: "camera", withConfiguration: config), for: .normal)
        button.layer.cornerRadius = 8
        button.tintColor = CustomColor.nomadBlue
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = CustomColor.nomadBlue?.cgColor
        button.addTarget(self, action: #selector(chooseCameraOrAlbum), for: .touchUpInside)
        return button
    }()
    
    private var addPhotoCell: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 15)
        button.setImage(UIImage(systemName: "plus", withConfiguration: config), for: .normal)
        button.layer.cornerRadius = 8
        button.tintColor = UIColor(hex: "3C3C43")?.withAlphaComponent(0.6)
        button.backgroundColor = UIColor(hex: "F5F5F5")
        button.addTarget(self, action: #selector(chooseCameraOrAlbum), for: .touchUpInside)
        return button
    }()
    
    private lazy var removePhotoCell: UIImageView = {
        var image = UIImage(named: "AppIcon")
        var imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.isHidden = true
        imageView.isUserInteractionEnabled = true
        imageView.addSubview(removeButton)
        removeButton.anchor(top: imageView.topAnchor, right: imageView.rightAnchor, paddingTop: 0, paddingRight: 0, width: 25, height: 25)
        return imageView
    }()
    
    private var removeButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 14)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.layer.backgroundColor = UIColor.black.withAlphaComponent(0.7).cgColor
        button.addTarget(self, action: #selector(removePhoto), for: .touchUpInside)
        return button
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline, weight: .regular)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 8
        button.backgroundColor = CustomColor.nomadBlue
        button.addTarget(self, action: #selector(saveReview), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Actions
    
    @objc func removePhoto() {
        let actionsheet =  UIAlertController(title: "사진을 지우시겠습니까?", message: nil, preferredStyle: .alert)
        let no = UIAlertAction(title: "취소", style: .cancel) { action in
            self.dismiss(animated: true, completion: nil)
        }
        let yes = UIAlertAction(title: "확인", style: .default) { action in
            self.addPhotoCell.isHidden = false
            self.removePhotoCell.isHidden = true
        }
        actionsheet.addAction(no)
        actionsheet.addAction(yes)
        present(actionsheet, animated: true, completion: nil)
    }
    
    @objc func chooseCameraOrAlbum() {
        let actionsheet =  UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "사진 촬영", style: .default) { action in
            self.showCamera()
        }
        let album = UIAlertAction(title: "갤러리에서 선택", style: .default) { action in
            self.showAlbum()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        actionsheet.addAction(camera)
        actionsheet.addAction(album)
        actionsheet.addAction(cancel)
        present(actionsheet, animated: true, completion: nil)
    }
    
    @objc func saveReview() {
        // TODO: alert이후에 저장을 하거나, 바로 저장을 하거나 선택해야함
        guard let user = Auth.auth().currentUser else { return }
        guard let placeUid = place?.placeUid else { return }
        var image = UIImage()
        if removePhotoCell.image != UIImage(named: "AppIcon") {
            image = removePhotoCell.image ?? UIImage()
        }
        let alert = UIAlertController(title: "리뷰 작성 완료하시겠습니까?", message: "리뷰를 작성을 완료합니다.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let save = UIAlertAction(title: "확인", style: .default) { action in
            FirebaseManager.shared.writeReview(review: Review(placeUid: placeUid, userUid: user.uid , reviewUid: UUID().uuidString, createTime: Date(), content: self.reviewTextView.text), image: image == UIImage() ? nil : image) {
                print("REVIEW SAVE Done")
                self.dismiss(animated: true)
            }
        }
        alert.addAction(cancel)
        alert.addAction(save)
        self.present(alert, animated: true)
    }
    
    @objc func dismissPage() {
        self.dismiss(animated: true)
    }
    
    // MARK: - Helpers
    
    func showCamera() {
        let camera = UIImagePickerController()
        camera.sourceType = .camera
        camera.allowsEditing = true
        camera.cameraDevice = .rear
        camera.delegate = self
        present(camera, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let album = UIImagePickerController()
        album.sourceType = .photoLibrary
        album.allowsEditing = true
        album.delegate = self
        present(album, animated: true, completion: nil)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 66, paddingRight: 17, width: 30, height: 30)
        view.addSubview(placeName)
        view.addSubview(shareExperienceText)
        placeName.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 96, paddingLeft: 18)
        shareExperienceText.anchor(top: placeName.bottomAnchor, left: view.leftAnchor, paddingTop: 9, paddingLeft: 18)
        view.addSubview(reviewTextView)
        reviewTextView.anchor(top: shareExperienceText.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 28, paddingLeft: 20, paddingRight: 20, height: 207)
        view.addSubview(addPhotoText)
        addPhotoText.anchor(top: reviewTextView.bottomAnchor, left: view.leftAnchor, paddingTop: 60, paddingLeft: 26)
        view.addSubview(addPhotoCell)
        addPhotoCell.anchor(top: addPhotoText.bottomAnchor, left: view.leftAnchor, paddingTop: 10, paddingLeft: 20, width: 110, height: 110)
        view.addSubview(removePhotoCell)
        removePhotoCell.anchor(top: addPhotoText.bottomAnchor, left: view.leftAnchor, paddingTop: 10, paddingLeft: 20, width: 110, height: 110)
        view.addSubview(checkButton)
        checkButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 20, paddingBottom: 33, paddingRight: 20, height: 46)
    }


}

// MARK: - UITextViewDelegate

extension ReviewDetailViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "리뷰를 입력해주세요." {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "리뷰를 입력해주세요."
            textView.textColor = CustomColor.nomadGray1
        }
    }
    
}

// MARK: - UIImagePickerControllerDelegate

extension ReviewDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            removePhotoCell.image = image
            addPhotoCell.isHidden = true
            removePhotoCell.isHidden = false
        }
        dismiss(animated: true, completion: nil)
    }
    
}
