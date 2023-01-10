//
//  CollectionViewCell.swift
//  BNomad
//
//  Created by 박진웅 on 2022/10/18.
//

import UIKit
import MapKit

class PlaceListCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: PlaceListCollectionViewCell.self)
    
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
            let distance: Double = Contents.calculateDistance(userLatitude: latitude, placeLatitude: place.latitude, userLongitude: longitude, placeLongitude: place.longitude)
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
    
    // MARK: - LifeCycle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        cellUI()
        configUI()
    }

    // MARK: - Helpers
    
    func cellUI() {
        self.layer.cornerRadius = 12
        self.backgroundColor = .white
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.05
        self.layer.shadowColor = CustomColor.nomadBlack?.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 4)
    }
    
    func configUI() {
        self.addSubview(cellStack)
        cellStack.anchor(left: self.leftAnchor, paddingLeft: 16)
        cellStack.centerY(inView: self)
        
        self.addSubview(workingLabel)
        workingLabel.anchor(bottom: self.bottomAnchor, right: self.rightAnchor, paddingBottom: 15, paddingRight: 15, width: 57, height: 20)
    }
}
