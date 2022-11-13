//
//  FirebaseManager.swift
//  BNomad
//
//  Created by 박성수 on 2022/10/17.
//

import Foundation
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseStorage
import UIKit

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


    // MARK: users
    // firebase
    //    users
    //        userUid
    //            nickname
    //            occupation
    //            introduction
    //            profileImageUrl

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
            let profileImageUrl = dictionary["profileImageUrl"] as? String
            let user = User(userUid: userUid, nickname: nickname, occupation: occupation, introduction: introduction, checkInHistory: nil, profileImageUrl: profileImageUrl)
            
            completion(user)
        })
    }

    /// 새로운 user 추가 & user 정보 업데이트
    func setUser(user: User) {
        self.ref.child("users").child(user.userUid).updateChildValues([
            "nickname": user.nickname,
            "occupation": user.occupation as Any,
            "introduction": user.introduction as Any,
            "profileImageUrl": user.profileImageUrl as Any
        ])
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
    
    // MARK: firebase - meetUpUser
    // meetUpUser
    //     userUid
    //         meetUpUid

    // MARK: firebase - meetUpPlace
    // meetUpPlace
    //     placeUid
    //         date
    //             meetUpUid
    //                 time
    //                 title
    //                 description
    //                 maxPeopleNum
    //                 currentPeopleUids
    //                 meetUpPlaceName
    //                 organizerUid

    // MARK: firebase - meetUp
    // meetUp
    //     meetUpUid
    //         placeUid
    //         time
    //         title
    //         description
    //         maxPeopleNum
    //         currentPeopleUids
    //         meetUpPlaceName
    //         organizerUid

    /// 새로운 meetUp을 생성
    /// completion로 place의 meetUpHistory에 MeetUp을 넘겨줘야함.
    func createMeetUp(meetUp: MeetUp, completion: @escaping (MeetUp) -> Void) {
        let currentPeopleUids = [meetUp.organizerUid: true]
        
        let meetUpUser = ["placeUid": meetUp.placeUid, "time": meetUp.time.toDateTimeString(),
                          "title": meetUp.title, "description": meetUp.description as Any,
                          "maxPeopleNum": meetUp.maxPeopleNum, "currentPeopleUids": currentPeopleUids,
                          "meetUpPlaceName": meetUp.meetUpPlaceName, "organizerUid": meetUp.organizerUid] as [String : Any]
        
        let meetUpPlace = ["time": meetUp.time.toDateTimeString(), "title": meetUp.title,
                           "description": meetUp.description as Any, "maxPeopleNum": meetUp.maxPeopleNum,
                           "currentPeopleUids": currentPeopleUids, "meetUpPlaceName": meetUp.meetUpPlaceName,
                           "organizerUid": meetUp.organizerUid] as [String : Any]
        
        ref.updateChildValues(["meetUpUser/\(meetUp.organizerUid)/\(meetUp.meetUpUid)" : true,
                               "meetUp/\(meetUp.meetUpUid)" : meetUpUser,
                               "meetUpPlace/\(meetUp.placeUid)/\(meetUp.date)/\(meetUp.meetUpUid)" : meetUpPlace]) {
            (error: Error?, ref: DatabaseReference) in
            if let error: Error = error {
                print("meetUp could not be saved: \(error).")
            } else {
                completion(meetUp)
            }
        }
    }

    /// place의 특정 날짜의 meetUp들 가져오기
    func fetchMeetUpHistory(placeUid: String, date: Date = Date(), completion: @escaping([MeetUp]) -> Void) {
        let date = date.toDateString()
        var meetUpHistory: [MeetUp] = []
        
        ref.child("meetUpPlace/\(placeUid)/\(date)").observeSingleEvent(of: .value, with: { snapshots in
            for child in snapshots.children {
                guard let snapshot = child as? DataSnapshot else { return }
                guard let meetUpDict = snapshot.value as? [String: Any] else { return }
                
                guard let time = meetUpDict["time"] as? String else { return }
                guard let title = meetUpDict["title"] as? String else { return }
                guard let maxPeopleNum = meetUpDict["maxPeopleNum"] as? Int else { return }
                guard let meetUpPlaceName = meetUpDict["meetUpPlaceName"] as? String else { return }
                guard let organizerUid = meetUpDict["organizerUid"] as? String else { return }
                
                guard let time = time.toDateTime() else { return }
                
                let currentPeopleUids = (meetUpDict["currentPeopleUids"] as? [String: Any])?.keys
                
                var currentPeopleUidsArray: [String] = []
                
                if let currentPeopleUids = currentPeopleUids {
                    currentPeopleUids.forEach { currentPeopleUidsArray.append($0)}
                }
                
                let description = meetUpDict["description"] as? String
                let meetUp = MeetUp(meetUpUid: snapshot.key, placeUid: placeUid, organizerUid: organizerUid, title: title, meetUpPlaceName: meetUpPlaceName, time: time, maxPeopleNum: maxPeopleNum, description: description, currentPeopleUids: currentPeopleUidsArray)
                meetUpHistory.append(meetUp)
            }
            completion(meetUpHistory)
        })
    }

    /// 특정 유저가 참여한 모든 meetUp의 Uid 가져오기
    func fetchMeetUpUidAll(userUid: String, completion: @escaping(String) -> Void) {
        
        ref.child("meetUpUser/\(userUid)").observeSingleEvent(of: .value, with: { snapshots in
            for child in snapshots.children {
                guard let snapshot = child as? DataSnapshot else { return }
                guard let meetUpUid = snapshot.key as? String else { return }
                completion(meetUpUid)
            }
        })
    }

    /// meetUpUid의 meetUp 가져오기
    func fetchMeetUp(meetUpUid: String, completion: @escaping(MeetUp) -> Void) {
        ref.child("meetUp/\(meetUpUid)").observeSingleEvent(of: .value, with: { snapshot in
            guard let meetUpDict = snapshot.value as? [String: Any] else { return }
            
            guard let placeUid = meetUpDict["placeUid"] as? String else { return }
            guard let time = meetUpDict["time"] as? String else { return }
            guard let title = meetUpDict["title"] as? String else { return }
            guard let maxPeopleNum = meetUpDict["maxPeopleNum"] as? Int else { return }
            guard let meetUpPlaceName = meetUpDict["meetUpPlaceName"] as? String else { return }
            guard let organizerUid = meetUpDict["organizerUid"] as? String else { return }
            
            guard let time = time.toDateTime() else { return }
            
            let currentPeopleUids = (meetUpDict["currentPeopleUids"] as? [String: Any])?.keys
            
            var currentPeopleUidsArray: [String] = []
            
            if let currentPeopleUids = currentPeopleUids {
                currentPeopleUids.forEach { currentPeopleUidsArray.append($0)}
            }
            
            let description = meetUpDict["description"] as? String
            
            let meetUp = MeetUp(meetUpUid: snapshot.key, placeUid: placeUid, organizerUid: organizerUid, title: title, meetUpPlaceName: meetUpPlaceName, time: time, maxPeopleNum: maxPeopleNum,description: description, currentPeopleUids: currentPeopleUidsArray)
            completion(meetUp)
        })
    }

    /// meetUp 참여하기
    /// completion으로 place - meetUpHistory - meetUp - currentPeopleUids에 userUid 추가
    /// completion으로 user - meetUpHistory에 meetUp 추가
    func participateMeetUp(userUid: String, meetUpUid: String, placeUid: String, completion: @escaping() -> Void) {
        let date = Date().toDateString()
        
        ref.updateChildValues(["meetUpUser/\(userUid)/\(meetUpUid)" : true,
                               "meetUp/\(meetUpUid)/currentPeopleUids/\(userUid)" : true,
                               "meetUpPlace/\(placeUid)/\(date)/\(meetUpUid)/currentPeopleUids/\(userUid)" : true]) {
            (error: Error?, ref: DatabaseReference) in
            if let error: Error = error {
                print("meetUp could not be saved: \(error).")
            } else {
                completion()
            }
        }
    }

    /// profile 이미지 업로드
    func uploadUserProfileImage(userUid: String, image: UIImage, completion: @escaping(String) -> Void) {
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("userProfileImage/\(userUid)")
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            print("DEBUG - fail compression")
            return
        }
        
        imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("DEBUG \(error.localizedDescription)")
                return
            }
            
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    print("DEBUG \(error.localizedDescription)")
                    return
                }
                
                guard let downloadURL = url else {
                    print("DEBUG - url fail")
                    return
                }
                completion(downloadURL.absoluteString)
            }
        }
    }

    /// 회원 탈퇴 사유 업로드
    func uploadUserWithdrawalReason(userUid: String, reason: String, completion: @escaping() -> Void) {
        ref.child("service/WithdrawalReason/\(userUid)").updateChildValues(["withdrawalReason" : reason]) {
            (error: Error?, ref: DatabaseReference) in
            if let error: Error = error {
                print("DEBUG \(error).")
            } else {
                completion()
            }
        }
    }
    
    /// 장소 제안 업로드
    func suggestPlace(placeName: String, placeAddress: String, recommendReason: String?, recommenderContactNumber: String?) {
        let dateTime: String = Date().toDateTimeString()
        ref.child("service/suggestPlace/\(dateTime)").updateChildValues(["placeName" : placeName,
                                                          "placeAddress" : placeAddress,
                                                          "recommendReason" : recommendReason,
                                                          "recommenderContactNumber" : recommenderContactNumber]) {
            (error: Error?, ref: DatabaseReference) in
            if let error: Error = error {
                print("DEBUG \(error).")
            }
        }
    }
    
}
