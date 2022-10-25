//
//  FirebaseManager.swift
//  BNomad
//
//  Created by 박성수 on 2022/10/17.
//

import Foundation
import FirebaseDatabase
import FirebaseDatabaseSwift

class FirebaseManager {
    
    static let shared = FirebaseManager()

    // 실사용시 withPath: "Dummy" 제거 필요.
    let ref = Database.database().reference(withPath: "Dummy")
    
    // MARK: place
    // firebase
    //    places
    //        placeUid
    //            type
    //            name
    //            latitude
    //            longitude
    //            contact
    //            address
        
    /// 모든 PlaceData를 가져오기
    func fetchPlaceAll(completion: @escaping(Place) -> Void) {
        ref.child("places").observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                guard
                    let snapshot = child as? DataSnapshot,
                    let dictionary = snapshot.value as? [String: Any],
                    let name = dictionary["name"] as? String,
                    let latitude = dictionary["latitude"] as? Double,
                    let longitude = dictionary["longitude"] as? Double
                else {
                    print("fail fetchPlaceData from firebase")
                    return
                }
                
                let placeUid = snapshot.key
                let contact = dictionary["contact"] as? String
                let address = dictionary["address"] as? String
                // TODO: - type 속성 추가
                let place = Place(placeUid: placeUid, name: name, latitude: latitude, longitude: longitude
                                  ,contact: contact, address: address)
                
                completion(place)
            }
        })
    }
    
    
    // MARK: user
    // firebase
    //    users
    //        userUid
    //            nickname
    //            occupation
    //            introduction
    //

    /// userUid 존재하는지 체크
    func checkUserExist(userUid: String, completion: @escaping(Bool) -> Void) {
        ref.child("users").child(userUid).observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    /// userData 가져오기
    func fetchUser(id userUid: String, completion: @escaping(User) -> Void) {
        ref.child("users/\(userUid)").observeSingleEvent(of: .value, with: { snapshot in
            guard
                let dictionary = snapshot.value as? [String: Any],
                let nickname = dictionary["nickname"] as? String
            else {
                print("fail fetchUser from firebase")
                return
            }
            let userUid = snapshot.key
            let occupation = dictionary["occupation"] as? String
            let introduction = dictionary["introduction"] as? String
            let user = User(userUid: userUid, nickname: nickname, occupation: occupation, introduction: introduction, checkInHistory: nil)
            
            completion(user)
        })
    }
    
    /// 새로운 user 추가 & user 정보 업데이트
    func setUser(user: User) {
        self.ref.child("users").child(user.userUid).setValue(user.toAnyObject())
    }
    
    
    // MARK: checkInUser
    // firebase
    //    checkInUser
    //        userUid
    //            checkInTime
    //                placeUid
    //                checkOutTime
    //                checkInUid
    
    /// user의 모든 CheckInHistory 가져오기
    func fetchCheckInHistory(userUid: String, completion: @escaping([CheckIn]) -> Void) {
        var checkInHistory: [CheckIn] = []
        ref.child("checkInUser/\(userUid)").observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                guard
                    let snapshot = child as? DataSnapshot,
                    let dictionary = snapshot.value as? [String: String],
                    let checkInTime = snapshot.key.toDateTime(),
                    let checkInUid = dictionary["checkInUid"],
                    let placeUid = dictionary["placeUid"]
                else {
                    print("fail user fetchCheckInHistory from firebase")
                    return
                }
    
                let checkOutTime = dictionary["checkOutTime"]?.toDateTime()
                let checkIn = CheckIn(userUid: userUid, placeUid: placeUid, checkInUid: checkInUid, checkInTime: checkInTime, checkOutTime: checkOutTime)
                
                checkInHistory.append(checkIn)
            }
            completion(checkInHistory)
        })
    }
    
    // MARK: checkInPlace
    // firebase
    //    checkInPlace
    //        placeUid
    //            date
    //                checkInUid
    //                    userUid
    //                    checkInTime
    //                    checkOutTime
        
    func getCheckInFromPlace(snapshot: Any, placeUid: String) -> CheckIn? {
        guard
            let snapshot = snapshot as? DataSnapshot,
            let dictionary = snapshot.value as? [String: String],
            let checkInUid = snapshot.key as? String,
            let userUid = dictionary["userUid"],
            let checkInTime = dictionary["checkInTime"]?.toDateTime()
        else {
            print("fail user fetchCheckInHistory from firebase")
            return nil
        }
        
        let checkOutTime = dictionary["checkOutTime"]?.toDateTime()
        let checkIn = CheckIn(userUid: userUid, placeUid: placeUid, checkInUid: checkInUid, checkInTime: checkInTime, checkOutTime: checkOutTime)
        
        return checkIn
    }
    
    /// (observeSingleEvent) 날짜별로 place의  checkInHistory 가져오기
    func fetchCheckInHistory(placeUid: String, date: Date = Date(), completion: @escaping([CheckIn]) -> Void) {
        let date = date.toDateString()
        var checkInHistory: [CheckIn] = []
        
        ref.child("checkInPlace/\(placeUid)/\(date)").observeSingleEvent(of: .value, with: { snapshots in
            for child in snapshots.children {
                guard let checkIn = self.getCheckInFromPlace(snapshot: child, placeUid: placeUid) else { return }
                checkInHistory.append(checkIn)
            }
            completion(checkInHistory)
        })
    }

    /// (observe) 날짜별로 place의  checkInHistory 가져오기
    func fetchCheckInHistoryObserve(placeUid: String, date: Date = Date(), completion: @escaping([CheckIn]) -> Void) {
        let date = date.toDateString()
        var checkInHistory: [CheckIn] = []
        
        ref.child("checkInPlace/\(placeUid)/\(date)").observe(.value, with: { snapshots in
            for child in snapshots.children {
                guard let checkIn = self.getCheckInFromPlace(snapshot: child, placeUid: placeUid) else { return }
                checkInHistory.append(checkIn)
            }
            completion(checkInHistory)
        })
    }

    /// (observeSingleEvent) 모든 place의 checkInHistory 가져오기
    func fetchCheckInHistoryAll(placeUid: String, completion: @escaping([CheckIn]) -> Void) {
        var checkInHistory: [CheckIn] = []
        
        ref.child("checkInPlace/\(placeUid)").observeSingleEvent(of: .value, with: { snapshots in
            for child in snapshots.children {
                guard let snapshot = child as? DataSnapshot else { return }
                for child in snapshot.children {
                    guard let checkIn = self.getCheckInFromPlace(snapshot: child, placeUid: placeUid) else { return }
                    checkInHistory.append(checkIn)
                }
            }
            completion(checkInHistory)
        })
    }

    /// checkIn할 경우 checkInUser, checkInPlace에 checkIn 데이터 추가
    func setCheckIn(checkIn: CheckIn, completion: @escaping(CheckIn) -> Void) {
        let checkInUser = ["checkInUid": checkIn.checkInUid, "placeUid": checkIn.placeUid, "checkOutTime": checkIn.checkOutTime?.toDateTimeString()]
        let checkInPlace = ["userUid": checkIn.userUid, "checkInTime": checkIn.checkInTime.toDateTimeString(), "checkOutTime": checkIn.checkOutTime?.toDateTimeString()]
        
        ref.updateChildValues(["checkInUser/\(checkIn.userUid)/\(checkIn.checkInTime.toDateTimeString())" : checkInUser,
                               "checkInPlace/\(checkIn.placeUid)/\(checkIn.date)/\(checkIn.checkInUid)" : checkInPlace]) { 
            (error: Error?, ref: DatabaseReference) in
            if let error: Error = error {
                print("checkIn could not be saved: \(error).")
            } else {
                completion(checkIn)
            }
        }
    }

    /// checkOut할 경우 checkInUser, checkInPlace에 checkOutTime 추가
    func setCheckOut(checkIn: CheckIn, completion: @escaping(CheckIn) -> Void) {
        var checkIn: CheckIn = checkIn
        let checkOutTime = Date()
        checkIn.checkOutTime = checkOutTime

        ref.updateChildValues(["checkInUser/\(checkIn.userUid)/\(checkIn.checkInTime.toDateTimeString())/checkOutTime" : checkOutTime.toDateTimeString(),
                               "checkInPlace/\(checkIn.placeUid)/\(checkIn.date)/\(checkIn.checkInUid)/checkOutTime" : checkOutTime.toDateTimeString()]) { 
            (error: Error?, ref: DatabaseReference) in
            if let error: Error = error {
                print("checkOut could not be saved: \(error).")
            } else {
                completion(checkIn)
            }
        }
    }
}
