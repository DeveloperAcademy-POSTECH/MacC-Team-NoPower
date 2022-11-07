//
//  FirebaseTestVC.swift
//  BNomad
//
//  Created by hyo on 2022/10/24.
//

import UIKit

class FirebaseTestVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // // 모든 place 가져오기
        // fetchPlaceAll()
        
        // // 특정 user 가져오기
        // fetchUser()
        
        // // user 업로드하기
        // setUser()
        
        // // user 수정하기
        // updateUser()

        // // user의 모든 체크인 데이터 가져오기
        // fetchCheckInHistoryUser()

        // // 특정 place의 특정 날짜 체크인 데이터 가져오기 observeSingleEvent
        // fetchCheckInHistoryPlace()
        
        // // 특정 place의 특정 날짜 체크인 데이터 가져오기 observe
        // fetchCheckInHistoryObserve()
        
        // // 특정 place의 모든 체크인 데이터 가져오기
        // fetchCheckInHistoryAll()
        
        // checkin 후 checkOut
        // setCheckIn() { user in
        //     self.setCheckOut(user: user)
        // }

        // // meetUp 생성
        // createMeetUp()

        // fetchMeetUpPlace()

         fetchMeetUpUser()
    }
    
    func fetchPlaceAll() {
        FirebaseManager.shared.fetchPlaceAll { place in
            print(place)
        }
    }
    
    func fetchUser() {
        let currentUserUid = "01b651da-79ce-4089-85ad-966d3a0463b0"
        FirebaseManager.shared.fetchUser(id: currentUserUid) { user in
            print(user)
        }
    }
    
    func setUser() {
        FirebaseManager.shared.setUser(user: DummyData.user1)
    }
    
    func updateUser() {
        var user = DummyData.user1
        user.introduction = "hi~"
        user.nickname = "liw"

        FirebaseManager.shared.setUser(user: user)
    }
    
    func fetchCheckInHistoryUser() {
        let userUid: String = "012f0180-669f-411e-91ee-dd45ee8d0cf7"
        
        FirebaseManager.shared.fetchCheckInHistory(userUid: userUid) { checkInHistory in
            print(checkInHistory)
        }
    }
    
    func fetchCheckInHistoryPlace() {
        let placeUid: String = "1db94005-c8bc-4a6a-a1ea-5c714b1c8bdc"
        let date: Date? = "2022-10-23".toDate()
        
        guard let date = date else {
            print("fail date")
            return
        }
        
        FirebaseManager.shared.fetchCheckInHistory(placeUid: placeUid, date: date) { checkInHistory in
            print(checkInHistory)
        }
    }

    func fetchCheckInHistoryObserve() {
        let placeUid: String = "1db94005-c8bc-4a6a-a1ea-5c714b1c8bdc"
        let date: Date? = "2022-10-23".toDate()
        
        guard let date = date else {
            print("fail date")
            return
        }
        
        FirebaseManager.shared.fetchCheckInHistoryObserve(placeUid: placeUid, date: date) { checkInHistory in
            print(checkInHistory[0])
        }
    }

    func fetchCheckInHistoryAll() {
        let placeUid: String = "1db94005-c8bc-4a6a-a1ea-5c714b1c8bdc"
        
        FirebaseManager.shared.fetchCheckInHistoryAll(placeUid: placeUid) { checkInHistory in
            print(checkInHistory.count)
        }
    }
    
    func setCheckIn(completion: @escaping(User) -> Void) {
        var user: User = User(userUid: "01925c0c-799d-4b05-bee7-bdc68f64737b", nickname: "lance")
        let placeUid: String = "1db94005-c8bc-4a6a-a1ea-5c714b1c8bdc"
        let checkIn: CheckIn = CheckIn(userUid: user.userUid, placeUid: placeUid, checkInUid: UUID().uuidString, checkInTime: Date())
        
        FirebaseManager.shared.setCheckIn(checkIn: checkIn) { checkIn in
            if user.checkInHistory == nil {
                user.checkInHistory = [checkIn]
            } else {
                user.checkInHistory?.append(checkIn)
            }

            print("checkIn 완료")
            print(checkIn)
            print(user.isChecked)
            print(user.currentPlaceUid)
            completion(user)
        }
    }

    func setCheckOut(user: User) {
        var user = user

        guard
            let checkIn = user.currentCheckIn,
            let checkInhistory = user.checkInHistory
        else {
            print("checkIn 이력이 없습니다.")
            return
        }

        FirebaseManager.shared.setCheckOut(checkIn: checkIn) { checkIn in
            let index = checkInhistory.firstIndex { $0.checkInUid == checkIn.checkInUid }
            guard let index = index else {
                print("fail index")
                return
            }
            user.checkInHistory?[index] = checkIn

            print("checkOut 완료")
            print(checkIn)
            print(user.isChecked)
            print(user.currentPlaceUid)
        }
    }

    func createMeetUp() {
        let placeUid = "05c61154-45fb-4f2e-99ae-e3f4d5ed8d80"
        let organizerUid = "7F57CF97-E200-4496-92C7-E7B30311D4F8"

        let meetUp = MeetUp(meetUpUid: UUID().uuidString, placeUid: placeUid, organizerUid: organizerUid, title: "국밥 먹을 사람?", meetUpPlaceName: "화장실 앞", time: Date(), maxPeopleNum: 4, description: "국최몇?")
                
        FirebaseManager.shared.createMeetUp(meetUp: meetUp) { meetUp in
            print(meetUp)
        }
    }

    func fetchMeetUpPlace() {
        let placeUid = "05c61154-45fb-4f2e-99ae-e3f4d5ed8d80"

        FirebaseManager.shared.fetchMeetUpHistory(placeUid: placeUid) { meetUpHistory in
            print(meetUpHistory)
        }        
    }

    func fetchMeetUpUidFromUser() {
        let userUid = "7F57CF97-E200-4496-92C7-E7B30311D4F8"

        FirebaseManager.shared.fetchMeetUpUidAll(userUid: userUid) { meetUpUid in
            print(meetUpUid)
        }
    }
    
    func fetchMeetUp() {
        let meetUid: String = "69F0CEAE-AD5C-4854-B6DE-1B33B8C6DBA7"

        FirebaseManager.shared.fetchMeetUp(meetUpUid: meetUid) { meetUp in
            print(meetUp)
        }
    }
    
}
