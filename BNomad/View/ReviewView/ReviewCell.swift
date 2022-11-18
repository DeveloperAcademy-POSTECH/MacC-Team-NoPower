//
//  ReviewCell.swift
//  BNomad
//
//  Created by 박진웅 on 2022/11/07.
//

import UIKit

class ReviewCell: UICollectionViewCell {
    
    static let identifier = "ReviewCell"

    // MARK: - Properties
        
    lazy var cell: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.addSubview(divider)
        view.addSubview(review)
        view.addSubview(userImage)
        view.addSubview(userName)

        divider.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 0.5)
        review.anchor(top: divider.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 21, paddingRight: 22)
        userImage.anchor(top: review.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, paddingTop: 4, paddingLeft: 21, paddingBottom: 11,  width: 20, height: 20)
        userName.centerY(inView: userImage, leftAnchor: userImage.rightAnchor, paddingLeft: 8)

        return view
    }()
    
    var divider: UIView = {
        let rectangle = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        rectangle.backgroundColor = UIColor(hex: "D3D3D3")
        return rectangle
    }()

    var photo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    lazy var review: UILabel = {
        let text = UILabel()
        text.backgroundColor = .clear
        text.textColor = .black
        text.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
        text.numberOfLines = 0
        text.lineBreakMode = .byWordWrapping
        text.text = "한줄 소개 입니다. 오늘 막거리 고 하나요. 어제는 집콕하며 여유를 즐겼는데~~ 오늘은 밖에서 뷰를 그리려니 심심합니다. 뭐가 난이도가 있다는 걸까요? 결국은 알아내는 사람이더라고요. WILL ZZANGZZANG 읏추 너무 춥습니다. 알쏭달쏭한 겨울입니다. 텍스트 길이제한이 없어서 아무말이나 적을 수 있답니다. 그래도 맥시멈을 설정해야할까요? 그렇게 많은 리뷰를 남길 것 같진 않은데.. 뭐 일단 해보죠!! 해봅시다 <3"
        text.textAlignment = .left
        return text
    }()

    private var userImage: UIImageView = {
        let image = UIImage(named: "AppIcon")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var userName: UILabel = {
        let text = UILabel()
        text.backgroundColor = .clear
        text.textColor = CustomColor.nomadGray1
        text.font = .preferredFont(forTextStyle: .caption1, weight: .regular)
        text.text = "랑스, 개발자"
        text.textAlignment = .center
        return text
    }()
    
    // MARK: - LifeCycle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
    }

    // MARK: - Helpers
    
    func setUpCell() {
        self.addSubview(cell)
        cell.anchor(top: self.topAnchor, width: UIScreen.main.bounds.width)
    }
}
