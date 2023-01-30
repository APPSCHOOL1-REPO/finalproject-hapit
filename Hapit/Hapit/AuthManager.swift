//
//  AuthManager.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/20.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class AuthManager: ObservableObject {
    var userInfoStore: User1 = User1(id: "", name: "", email: "", pw: "")
    
    let database = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    let currentUser = Auth.auth().currentUser ?? nil
    
    // MARK: - 신규회원 생성
    @MainActor
    func register(email: String, pw: String, name: String) async throws {
        do {
            //Auth에 유저등록
            let target = try await firebaseAuth.createUser(withEmail: email, password: pw).user
            
            // 신규회원 객체 생성
            let newby = User1(id: target.uid, name: name, email: email, pw: pw)
            
            // firestore에 신규회원 등록
            await uploadUserInfo(userInfo: newby)
            
        } catch {
            throw(error)
        }
    }
    
    // MARK: - 유저데이터 firestore에 업로드하는 함수
    func uploadUserInfo(userInfo: User1) async {
        do {
            try await database.collection("User")
                .document(userInfo.id)
                .setData([
                    "email" : userInfo.email,
                    "pw" : userInfo.pw,
                    "name" : userInfo.name,
                ])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - 이메일 중복확인을 해주는 함수
    @MainActor
    func isEmailDuplicated(email: String) -> Bool {
        var result = false
        
        database.collection("User").whereField("email", isEqualTo: email)
            .getDocuments() { (snapshot, err) in
                if let error = err {
                    print(error.localizedDescription)
                    return
                }
                
                guard let snapshot = snapshot else {
                    return
                }
                
                if snapshot.documents.isEmpty {
                    result = true
                } else {
                    result = false
                }
            }
        return result
    }
    
    
    // MARK: - 닉네임 중복확인을 해주는 함수
    @MainActor
    func isNicknameDuplicated(nickName: String) -> Bool {
        var result = false
        
        database.collection("User").whereField("name", isEqualTo: nickName)
            .getDocuments() { (snapshot, err) in
                if let error = err {
                    print(error.localizedDescription)
                    return
                }
                
                guard let snapshot = snapshot else {
                    return
                }
                
                if snapshot.documents.isEmpty {
                    result = true
                } else {
                    result = false
                }
            }
        return result
    }
}

