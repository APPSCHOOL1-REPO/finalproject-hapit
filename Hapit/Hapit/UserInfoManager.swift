//
//  UserInfoManager.swift
//  Hapit
//
//  Created by 이주희 on 2023/02/03.
//

import SwiftUI
import FirebaseFirestore

typealias SnapshotDataType = [String: Any]

final class UserInfoManager: ObservableObject {
    @Published var friendArray = [User]()
    @Published var currentUserInfo: User? = nil
    
    let database = Firestore.firestore()
    
    // MARK: - 현재 접속한 유저의 정보 불러오기
    // - parameters with: Auth.auth().currentUser.uid
    //싱글턴활용해보기
    func getCurrentUserInfo(currentUserUid: String?) async throws -> Void {
        guard let currentUserUid else { return }
        let userPath = database.collection("User").document("\(currentUserUid)")
        do {
            let snapshot = try await userPath.getDocument()
            if let requestedData = snapshot.data() {
                self.currentUserInfo = makeCurrentUser(with: requestedData, id: snapshot.documentID)
            }
        } catch {
            throw(error)
        }
    }
    
    func getUserInfoByUID(userUid: String?) async throws -> User? {
        var tempUser: User? = nil
        guard let userUid else { return nil }
        let userPath = database.collection("User").document("\(userUid)")
        do {
            let snapshot = try await userPath.getDocument()
            if let requestedData = snapshot.data() {
                tempUser = makeCurrentUser(with: requestedData, id: snapshot.documentID)
                guard let tempUser else { return nil}
                return tempUser
            }
            else {
                dump("\(#function) - DEBUG: NO SNAPSHOT FOUND")
            }
        } catch {
            throw(error)
        }
        return tempUser
    }
    
    // MARK: getCurrentUserInfo(), fetchUserInfo에서 사용할 함수
    private func makeCurrentUser(with requestedData: SnapshotDataType, id: String) -> User {
        let id: String = id
        let name: String = requestedData["name"] as? String ?? ""
        let email: String = requestedData["email"] as? String ?? ""
        let pw: String = requestedData["pw"] as? String ?? ""
        let proImage: String = requestedData["proImage"] as? String ?? ""
        let badge: [String] = requestedData["badge"] as? [String] ?? [""]
        let friends: [String] = requestedData["friends"] as? [String] ?? [""]
        
        let userInfo = User(id: id, name: name, email: email, pw: pw, proImage: proImage, badge: badge, friends: friends)
        
        return userInfo
    }
    
    // MARK: 현재 유저의 친구 정보 불러오기
    func getFriendArray(currentUserUid: String) async throws -> Void {
        //guard let currentUserUid else { return }
//        var uid = ""
//
//        if currentUserUid == nil{
//            uid = "0TNE4PomiUdal8xg4wsUevBmUNt1"
//        }else{
//            uid = currentUserUid ?? "Impossible"
//        }
        let target = try await database.collection("User").document(currentUserUid).getDocument()
        let docData = target.data()
        let friendList: [String] = docData?["friends"] as? [String] ?? [""]
        
        self.friendArray.removeAll()
        
        for friend in friendList {
            // 친구 아이디의 유저 경로
            let target = database.collection("User").document("\(friend)")
            do {
                let snapshot = try await target.getDocument()
                if let requestedData = snapshot.data() {
                    // 친구의 유저 정보 불러와서 배열에 더하기
                    let friendData = makeCurrentUser(with: requestedData, id: snapshot.documentID)
//                    DispatchQueue.main.async {
                        self.friendArray.append(friendData)
//                    }
                } else {
                    dump("\(#function) - DEBUG: NO SNAPSHOT FOUND")
                }
            } catch {
                throw(error)
            }
        }
    }
    
}
