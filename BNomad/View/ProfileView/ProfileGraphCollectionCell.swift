//
//  ProfileGraphCollectionCell.swift
//  BNomad
//
//  Created by Beone on 2022/10/25.
//


import UIKit

// TODO: 하드 코딩된 부분 제거
class ProfileGraphCollectionCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "ProfileGraphCollectionCell"
    
    var cellDate = ""
    var checkinTime: [String] = ["0", "0"]
    var checkoutTime: [String] = ["0", "0"]
    var startAnchor: CGFloat = 0
    var endAnchor: CGFloat = 0
    
    var checkInHistory: [CheckIn]? {
        didSet {
            guard let checkInHistory = checkInHistory else { return }
            
            for checkin in checkInHistory {
                if checkin.date == cellDate {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "H-m"
                    formatter.timeZone = TimeZone(identifier: "en")
                    
                    self.checkinTime = formatter.string(from: checkin.checkInTime).components(separatedBy: "-")
                    self.checkoutTime = formatter.string(from: checkin.checkOutTime ?? Date()).components(separatedBy: "-")
                    
                    //그래프의 시작/끝 픽셀 위치 잡아주는 계산
                    let startAnchorCalculater = (((Double(checkinTime[0]) ?? 0) + (Double(checkinTime[1]) ?? 0) * Double(1.0/60.0)) - Double(9)) * Double(154.0/9.0)
                    let endAnchorCalculater = Double(154.0) - ((((Double(checkoutTime[0]) ?? 0) + (Double(checkoutTime[1]) ?? 0) * Double(1.0/60.0)) - Double(9)) * Double(154.0/9.0))
                    
                    startAnchor = CGFloat(Int(startAnchorCalculater))
                    endAnchor = CGFloat(Int(endAnchorCalculater))
                    
                    contentView.addSubview(graphRectView)
                    graphRectView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: self.startAnchor, paddingBottom: self.endAnchor)
                    
                    
                    break
                } else {
                    graphRectView.removeFromSuperview()
                }
                
            }
        }
    }
    
    
    private let graphRectView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.nomadSkyblue
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(corder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    // MARK: - Helpers
    
    func render() {
        contentView.addSubview(graphRectView)
        graphRectView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: self.startAnchor, paddingBottom: self.endAnchor)
        
    }
    
}

