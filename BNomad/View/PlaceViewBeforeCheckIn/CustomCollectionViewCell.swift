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
    
    // MARK: - Properties
    
    var place: Place? {
        didSet {
            guard let place = place else {
                print("CustomCollectionViewCell : place 가져오기 실패" )
                return
            }
            self.name.text = place.name
            
            FirebaseManager.shared.fetchCheckInHistory(placeUid: place.placeUid) { checkInHistory in
                self.todayCheckInHistory = checkInHistory
            }
        }
    }
    
    var position: CLLocation? {
        didSet {
            guard let position = self.position else { return }
            guard let place = self.place else { return }
            let latitude: Double = position.coordinate.latitude
            let longitude: Double = position.coordinate.longitude
            let distance: Double = CustomCollectionViewCell.calculateDistance(latitude1: latitude, latitude2: place.latitude, longitude1: longitude, longitude2: place.longitude)
            self.distance.text = distance >= 1.0 ? String(round(distance * 10) / 10.0) + "km" : String(Int(round(distance * 1000))) + "m"
        }
    }
    
    var todayCheckInHistory: [CheckIn]? {
        didSet {
            guard let todayCheckInHistory = todayCheckInHistory else {
                print("CustomCollectionViewCell : todayCheckInHistory 가져오기 실패" )
                return
            }
            let history = todayCheckInHistory.filter { $0.checkOutTime == nil }
            self.numberOfCheckIn.text = "\(history.count)명 체크인"
            self.averageTime.text = CustomCollectionViewCell.calculateAverageTime(todayCheckInHistory: self.todayCheckInHistory)
        }
    }
    
    lazy var cell: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.backgroundColor = .white
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
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var distance: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        title.textColor = CustomColor.nomadGray1
        title.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        title.text = "1.5km"
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var averageTime: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        title.textColor = CustomColor.nomadGray1
        title.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
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
    
    static func calculateDistance(latitude1: Double, latitude2: Double, longitude1: Double, longitude2: Double) -> Double {
        let radLatitude1: Double = (latitude1 * .pi)/180
        let radLatitude2: Double = (latitude2 * .pi)/180
        let diffLat: Double = ((latitude2 - latitude1) * .pi)/180
        let diffLon: Double = ((longitude2 - longitude1) * .pi)/180
        let temp: Double = pow(sin(diffLat/2), 2) + cos(radLatitude1) * cos(radLatitude2) * pow(sin(diffLon/2), 2)
        let distance: Double = 2 * atan2(sqrt(temp), sqrt(1-temp)) * 6371
        return distance
    }
    
    static func calculateAverageTime(todayCheckInHistory: [CheckIn]?) -> String {
        var hour: Int
        var minute: Int
        var totalTime: Int = 0
        var averageTime: Int
        var stringTime: String
        
        guard let todayCheckInHistory = todayCheckInHistory else { return "fail"}
        let filterCheckInHistory = todayCheckInHistory.filter { $0.checkOutTime != nil }
        print("DEBUG:",filterCheckInHistory)
        for history in filterCheckInHistory {
            guard let checkOutTime = history.checkOutTime else { return "chekcOutt" }
            let totalMinute = Int(floor(checkOutTime.timeIntervalSince(history.checkInTime)/60))
            totalTime += totalMinute
        }
        
        if filterCheckInHistory.count != 0 {
            averageTime = abs(totalTime / filterCheckInHistory.count)
            hour = averageTime / 60
            minute = hour > 0 ? averageTime % hour : averageTime
            if hour > 0 && minute == 0 {
                stringTime = "평균 \(hour)시간 근무"
            } else if hour > 0 {
                stringTime = "평균 \(hour)시간 \(minute)분 근무"
            } else {
                stringTime = "평균 \(minute)분 근무"
            }
            print(stringTime)
        } else {
            return "평균 0시간"
        }
        return stringTime
    }
    
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
