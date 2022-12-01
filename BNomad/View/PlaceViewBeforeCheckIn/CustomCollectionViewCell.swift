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
            FirebaseManager.shared.fetchMeetUpHistory(placeUid: place.placeUid) { meetUpList in
                self.todayMeetUpList = meetUpList
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
            self.numberOfCheckIn.text = "\(history.count)명의 노마드"
            self.numberOfCheckIn.asColor(targetString: "\(history.count)명", color: CustomColor.nomadBlue ?? .label)
        }
    }
    
    var todayMeetUpList: [MeetUp]? {
        didSet {
            guard let todayMeetUpList = todayMeetUpList else { return }
            self.numberOfMeetUp.text = "\(todayMeetUpList.count)개의 밋업"
            self.numberOfMeetUp.asColor(targetString: "\(todayMeetUpList.count)개", color: CustomColor.nomadBlue ?? .label)
        }
    }
    
    lazy var cell: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .white
        view.layer.shadowRadius = 15
        view.layer.shadowOpacity = 0.05
        view.layer.shadowColor = CustomColor.nomadBlack?.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 4)
        return view
    }()
    
    var name: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        title.textColor = .black
        title.font = .preferredFont(forTextStyle: .headline)
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var numberOfCheckIn: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        title.textColor = CustomColor.nomadBlack
        title.font = .preferredFont(forTextStyle: .footnote)
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var numberOfMeetUp: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = CustomColor.nomadBlack
        label.textAlignment = .center
        
        return label
    }()
    
    var distance: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        title.textColor = CustomColor.nomadBlack
        title.font = .preferredFont(forTextStyle: .footnote)
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private let dot1View: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.nomadGray1
        view.anchor(width: 3, height: 3)
        view.layer.cornerRadius = 3/2
        
        return view
    }()
    
    private let dot2View: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.nomadGray1
        view.anchor(width: 3, height: 3)
        view.layer.cornerRadius = 3/2
        
        return view
    }()
    
    lazy var placeDetailStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [distance, dot1View, numberOfCheckIn, dot2View, numberOfMeetUp])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        
        return stack
    }()
    
    lazy var cellStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [name, placeDetailStack])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 10
        
        return stack
    }()
    
    var workingLabel: UILabel = {
        let label = UILabel()
        label.text = "열일중"
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .white
        label.backgroundColor = CustomColor.nomadBlue
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        
        return label
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
    
    // MARK: - LifeCycle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }

    // MARK: - Helpers
    
    func configUI() {
        let screenWidth = UIScreen.main.bounds.width
        let cellHeight = screenWidth * 80/390
        
        contentView.addSubview(cell)
        cell.anchor(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingLeft: 17, paddingRight: 17, height: cellHeight)
        
        self.addSubview(cellStack)
        cellStack.anchor(left: cell.leftAnchor, paddingLeft: 16)
        cellStack.centerY(inView: cell)
        
        self.addSubview(workingLabel)
        workingLabel.anchor(bottom: cell.bottomAnchor, right: cell.rightAnchor, paddingBottom: 15, paddingRight: 15, width: 57, height: 20)
    }
}
