//
//  ReviewDetailViewController.swift
//  BNomad
//
//  Created by 박진웅 on 2022/11/09.
//

import UIKit
import AVFoundation

class ReviewDetailViewController: UIViewController {

    var counter: Int = 1 {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        var config = UIImage.SymbolConfiguration(pointSize: 12)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        button.layer.cornerRadius = 15
        button.tintColor = UIColor(hex: "3C3C43")?.withAlphaComponent(0.6)
        button.backgroundColor = UIColor(hex: "F2F2F7")
//        button.addTarget(self, action: #selector(dismissPage), for: .touchUpInside)
        return button
    }()
    
    private let placeName: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        title.textColor = .black
        title.font = .preferredFont(forTextStyle: .title1, weight: .bold)
        title.text = "쌍사벅스"
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
//        textview.textInputView.backgroundColor = .white
        textview.font = .preferredFont(forTextStyle: .body, weight: .regular)
        textview.textColor = .black
        textview.layer.borderWidth = 1
        textview.layer.borderColor = CustomColor.nomadBlue?.cgColor
        textview.layer.cornerRadius = 8
//        textview.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
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
//        button.layer.opacity = 0.5
        button.addTarget(self, action: #selector(chooseCameraOrAlbum), for: .touchUpInside)
        return button
    }()
    
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
    
    func showCamera() {
        let camera = UIImagePickerController()
        camera.sourceType = .camera
        camera.allowsEditing = true
        camera.cameraDevice = .rear
//        camera.cameraCaptureMode = .photo
//        camera.delegate = self
        present(camera, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let album = UIImagePickerController()
        album.sourceType = .photoLibrary
        album.allowsEditing = true
        present(album, animated: true, completion: nil)
    }

    private lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline, weight: .regular)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 8
        button.backgroundColor = CustomColor.nomadBlue
//        button.addTarget(self, action: #selector(chooseCameraOrAlbum), for: .touchUpInside)
        return button
    }()
    
    private let layout: UICollectionViewFlowLayout = {
        let guideline = UICollectionViewFlowLayout()
        guideline.scrollDirection = .vertical
        guideline.minimumLineSpacing = 9
        guideline.minimumInteritemSpacing = 0
        return guideline
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        view.scrollIndicatorInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 4)
        view.contentInset = .zero
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.dataSource = self
        view.delegate = self
        view.register(AddPhotoCell.self, forCellWithReuseIdentifier: AddPhotoCell.identifier)
        view.register(RemovePhotoCell.self, forCellWithReuseIdentifier: RemovePhotoCell.identifier)
        return view
    }()
        
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        view.addSubview(collectionView)
        collectionView.anchor(top: addPhotoText.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 95, paddingRight: 20)
        view.addSubview(checkButton)
        checkButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 20, paddingBottom: 33, paddingRight: 20, height: 46)
    }

}

extension ReviewDetailViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "리뷰를 입력해주세요." {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "리뷰를 입력해주세요."
            textView.textColor = CustomColor.nomadGray1
        }
    }
    
}

// MARK: - UIImagePickerControllerDelegate

extension ReviewDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

}

// MARK: - UICollectionViewDataSource

extension ReviewDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.counter
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        guard let addingCell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPhotoCell.identifier, for: indexPath) as? AddPhotoCell else { return UICollectionViewCell() }
        guard let removingCell = collectionView.dequeueReusableCell(withReuseIdentifier: RemovePhotoCell.identifier, for: indexPath) as? RemovePhotoCell else { return UICollectionViewCell() }
        if indexPath.item == self.counter - 1 {
            cell = addingCell
        } else {
            cell = removingCell
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                chooseCameraOrAlbum()
                self.counter += 1
            }
            dismiss(animated: true)
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

}

// MARK: - UICollectionViewDelegate

extension ReviewDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chooseCameraOrAlbum()
        self.counter += 1
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ReviewDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width-64)/3, height: (UIScreen.main.bounds.width-64)/3)
    }
    
}
