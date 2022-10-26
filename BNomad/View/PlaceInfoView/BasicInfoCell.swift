//
//  BasicInfoCell.swift
//  BNomad
//
//  Created by 유재훈 on 2022/10/20.
//

import UIKit

class BasicInfoCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var place: Place? {
        didSet {
            guard let place = place else { return }
            mappingPlaceData(place)
        }
    }

//    var place: Place = DummyData.place1

    static let cellIdentifier = "BasicInfoCell"
    let basicInfoTitleLabel = UILabel()
    
    let phoneImage = UIImageView()
    let phoneNumberLabel = UILabel()
    let divider = UIView()
    
    let mapImage = UIImageView()
    let addressLabel = UILabel()
    let divider2 = UIView()
    
    let clockImage = UIImageView()
    let operatingStatusLabel = UILabel()
    let divider3 = UIView()
    
    let ticketImage = UIImageView()
    let priceLabel = UILabel()
    let divider4 = UIView()
    
    let infoSuggestionButton = UIButton()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        configureUI()
    }
    
    
    // MARK: - Helpers
    
    private func configureUI() {
        self.addSubview(basicInfoTitleLabel)
        self.addSubview(phoneImage)
        self.addSubview(phoneNumberLabel)
        self.addSubview(divider)
        self.addSubview(mapImage)
        self.addSubview(addressLabel)
        self.addSubview(divider2)
        self.addSubview(clockImage)
        self.addSubview(operatingStatusLabel)
        self.addSubview(divider3)
        self.addSubview(ticketImage)
        self.addSubview(priceLabel)
        self.addSubview(divider4)
        self.addSubview(infoSuggestionButton)
        setAttributes()
        guard let place = place else { return }
        mappingPlaceData(place)
    }
    
    private func setAttributes() {
        basicInfoTitleLabel.text = "기본 정보"
        basicInfoTitleLabel.font = UIFont.preferredFont(forTextStyle: .title3, weight: .semibold)
        basicInfoTitleLabel.textColor = CustomColor.nomadBlue
        basicInfoTitleLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 49, paddingLeft: 155)
        
        phoneImage.image = UIImage(systemName: "phone")
        phoneImage.tintColor = UIColor.black
        phoneImage.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 101, paddingLeft: 20)
        
        phoneNumberLabel.text = "080-000-0000"
        phoneNumberLabel.font = UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        phoneNumberLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 102, paddingLeft: 57)
        
        divider.backgroundColor = CustomColor.nomadGray3
        divider.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        divider.widthAnchor.constraint(equalToConstant: 350).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 132, paddingLeft: 20)
        
        mapImage.image = UIImage(systemName: "map")
        mapImage.tintColor = UIColor.black
        mapImage.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 144, paddingLeft: 20)
        
        addressLabel.text = "제주도 서귀포시 향교로"
        addressLabel.font = UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        addressLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 145, paddingLeft: 57)
        
        divider2.backgroundColor = CustomColor.nomadGray3
        divider2.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        divider2.widthAnchor.constraint(equalToConstant: 350).isActive = true
        divider2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider2.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 175, paddingLeft: 20)

        
        clockImage.image = UIImage(systemName: "clock")
        clockImage.tintColor = UIColor.black
        clockImage.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 187, paddingLeft: 20)
        
        operatingStatusLabel.text = "영업 중"
        operatingStatusLabel.font = UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        operatingStatusLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 188, paddingLeft: 57)
        
        
        divider3.backgroundColor = CustomColor.nomadGray3
        divider3.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        divider3.widthAnchor.constraint(equalToConstant: 350).isActive = true
        divider3.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider3.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 218, paddingLeft: 20)

        ticketImage.image = UIImage(systemName: "ticket")
        ticketImage.tintColor = UIColor.black
        ticketImage.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 231, paddingLeft: 20)
        
        priceLabel.text = "1일 ---- 15,000원"
        priceLabel.font = UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        priceLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 230, paddingLeft: 59)
        
        divider4.backgroundColor = CustomColor.nomadGray3
        divider4.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        divider4.widthAnchor.constraint(equalToConstant: 350).isActive = true
        divider4.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider4.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 260, paddingLeft: 20)
        
        infoSuggestionButton.setTitle("정보수정 제안", for: .normal)
        infoSuggestionButton.setTitleColor(CustomColor.nomadGray1, for: .normal)
        infoSuggestionButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption2, weight: .regular)
        infoSuggestionButton.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 268, paddingLeft: 20)

        
    }
    
    func mappingPlaceData(_ place: Place) {
        // 영업중 표기 등 추가 수정 필요
        phoneNumberLabel.text = place.contact
        addressLabel.text = place.address
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
