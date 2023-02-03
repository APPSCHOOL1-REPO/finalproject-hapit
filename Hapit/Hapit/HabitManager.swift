//
//  HabitManager.swift
//  Hapit
//
//  Created by greenthings on 2023/01/17.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import FirebaseAuth

final class HabitManager: ObservableObject{
    
    enum FirebaseError: Error{
        case badSnapshot
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    let currentUser = Auth.auth().currentUser ?? nil
    
    // 특수한 조건(예로, 66일)이 되었을때, challenges 배열에서 habits 배열에 추가한다.
    // challenges 에서는 제거를 한다.
    @Published var challenges: [Challenge] = []
    @Published var habits: [Challenge] = []
    @Published var posts: [Post] = []
    
    let database = Firestore.firestore()
    
    func fetchChallengeCombine() -> AnyPublisher<[Challenge], Error>{
        
        Future<[Challenge], Error> {  promise in
            
            self.database.collection("Challenge")
                .order(by: "createdAt", descending: true)
                .getDocuments{(snapshot, error) in
                    
                    if let error = error {
                        promise(.failure (error))
                        return
                    }
                    
                    guard let snapshot = snapshot else {
                        promise(.failure (FirebaseError.badSnapshot))
                        return
                    }
                    
                    snapshot.documents.forEach { document in
                        if let challenge = try? document.data(as: Challenge.self){
                            self.challenges.append(challenge)
                        }
                    }
                    promise(.success(self.challenges))
                }
        }
        .eraseToAnyPublisher()
    }
    
    func loadChallenge(){
        
        challenges.removeAll()
        
        self.fetchChallengeCombine()
            .sink { (completion) in
                switch completion{
                case .failure(_):
                    return
                case .finished:
                    return
                }
            } receiveValue: { [weak self] (challenges) in
                self?.challenges = challenges
            }
            .store(in: &cancellables)
    }
    
    func create(_ challenge: Challenge) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            self.database.collection("Challenge")
                .document(challenge.id)
                .setData([
                    "id": challenge.id,
                    "creator": challenge.creator,
                    "mateArray": challenge.mateArray,
                    "challengeTitle": challenge.challengeTitle,
                    "createdAt": challenge.createdAt,
                    "count": challenge.count,
                    "isChecked": challenge.isChecked,
                    "uid": challenge.uid
                ]) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    func createChallenge(challenge: Challenge){
        self.create(challenge)
            .sink { (completion) in
                switch completion{
                case .failure(_):
                    return
                case .finished:
                    return
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    // MARK: - 서버의 Challenge Collection에서 Challenge 객체 하나를 삭제하는 Method
    func removeChallenge(challenge: Challenge) {
        database.collection("Challenge")
            .document(challenge.id).delete()
        loadChallenge()
    }
    
    // MARK: - Update a Habit
    @MainActor
    func updateChallenge() async{
        // Update a Habit
    }
    
    // MARK: - Update a Habit
    func updateChallengeIsChecked(challenge: Challenge) -> AnyPublisher<[Challenge], Error> {
        // Update a Challenge
        // Local
        let isChecked = challenge.isChecked
        // TO server
        var check: Bool{
            if isChecked == true{
                return false
            }else{
                return true
            }
        }
        
        return Future<[Challenge], Error> {  promise in
            
            self.database.collection("Challenge")
                .document(challenge.id)
                .updateData(["isChecked": check])
            promise(.success(self.challenges))
            
        }
        .eraseToAnyPublisher()
    }
    
    func loadChallengeIsChecked(challenge: Challenge){
        self.updateChallengeIsChecked(challenge: challenge)
            .sink { (completion) in
                switch completion{
                case .failure( _):
                    return
                case .finished:
                    return
                }
            } receiveValue: { [weak self] (challenges) in
                self?.challenges = challenges
            }
            .store(in: &cancellables)
        loadChallenge()
    }
    
    // MARK: - R: Fetch Posts 함수 (Service)
    @MainActor
    func fetchPosts(challengeID: String, userID: String) -> AnyPublisher<[Challenge], Error>{
        
        Future<[Challenge], Error> {  promise in
            
            let query = self.database.collection("Post")
                .whereField("uid", isEqualTo: userID)
                .whereField("challengeID", isEqualTo: challengeID)
            
            query.getDocuments{(snapshot, error) in
                
                if let error = error {
                    promise(.failure (error))
                    return
                }
                
                guard let snapshot = snapshot else {
                    promise(.failure (FirebaseError.badSnapshot))
                    return
                }
                
                snapshot.documents.forEach { document in
                    if let post = try? document.data(as: Post.self){
                        self.posts.append(post)
                    }
                }
                
                promise(.success(self.challenges))
                
            }
            
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - R: Fetch Posts 함수 (ViewModel)
    @MainActor
    func loadPosts(challengeID: String, userID: String){
        posts.removeAll()
        
        self.fetchPosts(challengeID: challengeID, userID: userID)
            .sink { (completion) in
                switch completion{
                case .failure(_):
                    return
                case .finished:
                    return
                }
            } receiveValue: { [weak self] (challenges) in
                self?.challenges = challenges
            }
            .store(in: &cancellables)
    }
    
    // MARK: - C: Create Post 함수 (Service)
    func createService(_ post: Post) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            self.database.collection("Post")
                .document()
                .setData([
                    "id": post.id,
                    "uid": post.uid,
                    "challengeID": post.challengeID,
                    "title": post.title,
                    "content": post.content,
                    "createdAt": post.createdAt
                ]) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - C: Post Create 함수 (ViewModel)
    func createPost(post: Post){
        self.createService(post)
            .sink { (completion) in
                switch completion{
                case .failure(_):
                    return
                case .finished:
                    return
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    // MARK: - U: Post Update 함수 (Service)
    func updatePostService(_ post: Post) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            self.database.collection("Post")
                .document(post.id)
                .updateData(["content" : post.content]) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - U: Post Update 함수 (ViewModel)
    func updatePost(post: Post) {
        self.updatePostService(post)
            .sink { (completion) in
                switch completion{
                case .failure(_):
                    return
                case .finished:
                    return
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
