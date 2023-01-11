//
//  LiteralContents.swift
//  BNomad
//
//  Created by Beone on 2022/10/19.
//

import UIKit
import MapKit

struct Contents {
    
    //MARK: -Properties
    
    //오늘의 요일을 저장하는 변수
    static var todayOfTheWeek: Int{
        let formatter = DateFormatter()
        formatter.dateFormat = "e"    //e는 1~7(sun~sat)
        let day = formatter.string(from:Date())
        let interval = Int(day)
        return interval!
    }

    //MARK: - Functions

    //년, 월, 날자, 요일 반환하는 함수
    static func dateLabelMaker() -> [[String]] {
        
        var labelList: [[String]] = Array(repeating: [], count: 7)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "us")
        formatter.dateFormat = "yyyy-MMM-d-EEE"
        
        for day in 0..<7 {
            let dayAdded = (86400 * (1-Contents.todayOfTheWeek+day)) //일요일부터 차례로
            let oneDayString = formatter.string(from: Date(timeIntervalSinceNow: TimeInterval(dayAdded))).components(separatedBy: "-")
            oneDayString.forEach {
                labelList[day].append($0)
            }
        }
        return labelList
    }
    
    static func todayDate() -> [String: Int] {
        let calendar = Calendar.current
        let nowCalendarDate = Date()
        let year = calendar.component(.year, from: nowCalendarDate)
        let month = calendar.component(.month, from: nowCalendarDate)
        let day = calendar.component(.day, from: nowCalendarDate)
        
        return ["year": year, "month": month, "day": day]
    }
    
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    static func calculateDistance(userLatitude: Double, placeLatitude: Double, userLongitude: Double, placeLongitude: Double) -> Double {
        let radLatitude1: Double = (userLatitude * .pi)/180
        let radLatitude2: Double = (placeLatitude * .pi)/180
        let diffLat: Double = ((placeLatitude - userLatitude) * .pi)/180
        let diffLon: Double = ((placeLongitude - userLongitude) * .pi)/180
        let temp: Double = pow(sin(diffLat/2), 2) + cos(radLatitude1) * cos(radLatitude2) * pow(sin(diffLon/2), 2)
        let distance: Double = 2 * atan2(sqrt(temp), sqrt(1-temp)) * 6371
        return distance
    }

}
