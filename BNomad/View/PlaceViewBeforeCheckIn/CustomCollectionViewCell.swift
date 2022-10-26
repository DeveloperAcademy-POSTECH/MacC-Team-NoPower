//
//  CollectionViewCell.swift
//  BNomad
//
//  Created by 박진웅 on 2022/10/18.
//

import UIKit
import MapKit


// TODO: - 하드코딩된 부분 전부 변경 필요. Place 객체 받아서.
class CustomCollectionViewCell: UICollectionViewCell {

    static let identifier = "CustomCollectionViewCell"

    var position: CLLocation?
    // MARK: - Properties
    
    func calculateDistance(latitude1: Double, latitude2: Double, longitude1: Double, longitude2: Double) -> Double {
        let radLatitude1: Double = (latitude1 * .pi)/180
        let radLatitude2: Double = (latitude2 * .pi)/180
        let diffLat: Double = ((latitude2 - latitude1) * .pi)/180
        let diffLon: Double = ((longitude2 - longitude1) * .pi)/180
        let temp: Double = pow(sin(diffLat/2), 2) + cos(radLatitude1) * cos(radLatitude2) * pow(sin(diffLon/2), 2)
        let distance: Double = 2 * atan2(sqrt(temp), sqrt(1-temp)) * 6371
        return distance
    }
    
    func calculateAverageTime(place: Place) -> String {
        var hour: Int
        var minute: Int
        var totalTime: Int = 0
        var averageTime: Int
        var stringTime: String
        guard let totalCheckInHistory = place.totalCheckInHistory else { return "Error"}
        for place in totalCheckInHistory {
            guard let checkOutTime = place.checkOutTime else { return "Error"}
            let totalMinute = Int(floor(checkOutTime.timeIntervalSince(place.checkInTime)/60))
            totalTime += totalMinute
        }
        averageTime = abs(totalTime / totalCheckInHistory.count)
        hour = averageTime / 60
        minute = averageTime - hour
        stringTime = "\(hour)시간 \(minute)분"
        return stringTime
    }
    
    var place: Place? {
        didSet {
            guard let place = place else { return }
            self.name.text = place.name
            guard let latitude = position?.coordinate.latitude else { return }
            guard let longitude = position?.coordinate.longitude else { return }
            let distance: Double = calculateDistance(latitude1: latitude, latitude2: place.latitude, longitude1: longitude, longitude2: place.longitude)
            self.distance.text = distance >= 1.0 ? String(round(distance * 10) / 10.0) + "km" : String(Int(round(distance * 1000))) + "m"
            guard let current = place.currentCheckIn else { return }
            // TODO: 여기 이후에 self.distance.text 넣으면 안되는 이유가 currentCheckIn 이 nil 값이어서 return 이 되서 그 이후가 실행이 안됨
            self.numberOfCheckIn.text = String(current.count) + " 명 체크인"
            self.averageTime.text = calculateAverageTime(place: place)
        }
    }
    
    lazy var cell: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.addSubview(name)
        view.addSubview(numberOfCheckIn)
        view.addSubview(distance)
        view.addSubview(averageTime)
        view.addSubview(arrow)
        name.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 23, paddingLeft: 9)
        numberOfCheckIn.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 26, paddingRight: 50)
        distance.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 11, paddingBottom: 8)
        averageTime.anchor(bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: 8, paddingRight: 48)
        arrow.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        arrow.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12.45).isActive = true
        return view
    }()
    
    var name: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        title.textColor = .black
        title.font = .preferredFont(forTextStyle: .title2, weight: .bold)
        title.text = "스타스타"
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var numberOfCheckIn: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        title.textColor = .black
        title.font = .preferredFont(forTextStyle: .body, weight: .regular)        
        title.text = "9명 체크인"
        title.font = UIFont(name: "SFProText-Regular", size: 17)
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var distance: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        title.textColor = CustomColor.nomadGray2
        title.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        title.text = "1.5km"
        title.font = UIFont(name: "SFProText-Regular", size: 15)
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var averageTime: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        title.textColor = CustomColor.nomadGray2
        title.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        // TODO: - "평균 \()시간 근무" 처럼 문자열 포맷팅 형식으로 변경 필요
        title.text = "평균 5시간 근무"
        title.font = UIFont(name: "SFProText-Regular", size: 13)
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    let arrow: UIImageView = {
        let image = UIImage(systemName: "chevron.right")?.withTintColor(CustomColor.nomadBlue ?? .blue, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        contentView.addSubview(cell)
        cell.anchor(top: self.topAnchor, width: 356, height: 86)
        cell.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
}
