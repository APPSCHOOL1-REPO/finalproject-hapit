//
//  Post.swift
//  Hapit
//

import Foundation
//import FirebaseFirestoreSwift

struct Post: Identifiable, Codable {
    
    // 고유 아이디
    var id: String
    // 이 포스트를 만든 유저 아이디
    var creatorID: String
    // 이 포스트가 속한 챌린지 아이디
    var challengeID: String
    // 제목
    var title: String
    // 내용
    var content: String
    // 생성 날짜
    var createdAt: Date
    // 생성
    var createdDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: createdAt)
    }

}
