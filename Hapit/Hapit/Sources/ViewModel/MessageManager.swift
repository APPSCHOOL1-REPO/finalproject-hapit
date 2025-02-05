//
//  MessageManager.swift
//  Hapit
//
//  Created by 이주희 on 2023/02/07.
//

import SwiftUI
import FirebaseFirestore

@MainActor
final class MessageManager: ObservableObject {
    @Published var messageArray = [Message]()
    @Published var friendMessageArray = [Message]()
    let database = Firestore.firestore()
    
    // MARK: 메시지 보내기 (CREATE)
    // - 친구 신청, 친구 수락, 친구 완료, 콕찌르기
    func sendMessage(_ msg: Message) async throws -> Void {
        do {
            try await database.collection("User")
                .document(msg.receiverID)
                .collection("Message")
                .document(msg.id)
                .setData([
                    "alarmType": msg.messageType,
                    "sendTime": msg.sendTime,
                    "senderID": msg.senderID,
                    "receiverID": msg.receiverID,
                    "isRead": msg.isRead,
                    "challengeID": msg.challengeID
                ])
        } catch {
            throw(error)
        }
    }
    
    // MARK: 메시지 삭제
    // - 친구 수락, 친구 거절, 일정 시간 초과, x버튼
    func removeMessage(userID: String, messageID: String) async throws -> Void {
        do {
            try await database.collection("User")
                .document(userID)
                .collection("Message")
                .document(messageID).delete()
            try await fetchMessage(userID: userID)
        } catch {
            throw(error)
        }
    }
    
    // MARK: 메시지 불러오는 함수
    func fetchMessage(userID: String) async throws -> Void {
        do {
            let snapshot = try await database.collection("User")
                .document(userID).collection("Message")
                .order(by: "sendTime", descending: true)
                .getDocuments()
            self.messageArray.removeAll()
            
            for document in snapshot.documents {
                let id: String = document.documentID
                let docData = document.data()
                let messageType: String = docData["alarmType"] as? String ?? ""
                let senderID: String = docData["senderID"] as? String ?? ""
                let receiverID: String = docData["receiverID"] as? String ?? ""
                let isRead: Bool = docData["isRead"] as? Bool ?? false
                let challengeID: String = docData["challengeID"] as? String ?? ""
                if let sendStamp = docData["sendTime"] as? Timestamp {
                    let sendTime = sendStamp.dateValue()
                    let msgData: Message = Message(id: id,
                                                   messageType: messageType,
                                                   sendTime: sendTime,
                                                   senderID: senderID,
                                                   receiverID: receiverID,
                                                   isRead: isRead,
                                                   challengeID: challengeID)
                    self.messageArray.append(msgData)
                }
            }
        } catch {
            throw(error)
        }
    }
    
    // MARK: 친구 메시지 불러오는 함수 (친구 신청 중복 막기 위함)
    func fetchFriendMessage(userID: String) async throws -> [Message] {
        do {
            let snapshot = try await database.collection("User")
                .document(userID).collection("Message")
                .order(by: "sendTime", descending: true)
                .getDocuments()
            self.friendMessageArray.removeAll()
            
            for document in snapshot.documents {
                let id: String = document.documentID
                let docData = document.data()
                let messageType: String = docData["alarmType"] as? String ?? ""
                let senderID: String = docData["senderID"] as? String ?? ""
                let receiverID: String = docData["receiverID"] as? String ?? ""
                let isRead: Bool = docData["isRead"] as? Bool ?? false
                let challengeID: String = docData["challengeID"] as? String ?? ""
                if let sendStamp = docData["sendTime"] as? Timestamp {
                    let sendTime = sendStamp.dateValue()
                    let msgData: Message = Message(id: id,
                                                   messageType: messageType,
                                                   sendTime: sendTime,
                                                   senderID: senderID,
                                                   receiverID: receiverID,
                                                   isRead: isRead,
                                                   challengeID: challengeID)
                    self.friendMessageArray.append(msgData)
                }
            }
            let msgArr = self.friendMessageArray
            return msgArr
        } catch {
            throw(error)
        }
    }

    // MARK: Message 읽음 처리 해주는 함수
    func updateIsRead(userID: String, messageID: String) async throws -> Void {
        let path = database.collection("User")
            .document(userID)
            .collection("Message")
            .document(messageID)
        do {
            try await path.updateData(["isRead": true])
        } catch {
            throw(error)
        }
    }
}
