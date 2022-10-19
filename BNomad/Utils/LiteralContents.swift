//
//  LiteralContents.swift
//  BNomad
//
//  Created by Beone on 2022/10/19.
//

import UIKit

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
}
