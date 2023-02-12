//
//  PostModalView.swift
//  Hapit
//
//  Created by 박진형 on 2023/02/01.
//

import SwiftUI

struct PostModalView: View {
    @Binding var postsForModalView: [Post]
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var userInfoManager: UserInfoManager
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var modalManager: ModalManager
    var userInfos: [User] {
        return habitManager.currentMateInfos
    }
    @State var currentPost: Post = Post(id: "", uid: "", challengeID: "", title: "", content: "", createdAt: Date())
    @State var isLoading: Bool = true
    @State var selectedMember: String = ""
    
    var body: some View {
        
        VStack{
            if postsForModalView.isEmpty {
                EmptyCellView(currentContentsType: .post)
            }
            else {
                // MARK: 챌린지를 진행하는 사람이 혼자인 경우
                // 스크롤 뷰를 띄우지 않고 바로 컨텐츠를 보여준다.
                if userInfos.count == 1{
                    VStack(alignment: .leading){
                        Text("제목: \(postsForModalView[0].title)")
                            .font(.custom("IMHyemin-Bold", size: 22))
                            .foregroundColor(Color("DiaryTitle"))
                            .padding([.top, .bottom])
                
                        HStack{
                            Text(postsForModalView[0].content)
                                .font(.custom("IMHyemin-Regular", size: 15))
                                .foregroundColor(Color("DiaryContents"))
                            Spacer()
                        }
                        Spacer()
                    }
                } else{
                    // MARK: 챌린지를 진행하는 사람이 여럿인 경우
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(userInfos, id: \.self){ userinfo in
                                VStack{
                                    Button {
                                        //MARK: 버튼을 누르면 selectedUser의 값이 변경된다.
                                        selectedMember = userinfo.id
                                        for post in postsForModalView {
                                            if post.uid == selectedMember {
                                                currentPost = post
                                            }
                                            else {
                                                currentPost = Post(id: "", uid: "", challengeID: "", title: "", content: "", createdAt: Date())
                                            }
                                        }
                                    } label: {
                                        VStack{
                                            Image("\(userinfo.proImage)")
                                                .resizable()
                                                .frame(width: 44, height: 44)
                                                .aspectRatio(contentMode: .fit)
                                                .offset(y: 10)
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(selectedMember == userinfo.id ? Color.green : Color.gray, lineWidth: selectedMember == userinfo.id ? 3 : 2))
                                            Text(userinfo.name)
                                                .foregroundColor(selectedMember == userinfo.id ? Color("AccentColor") : .gray)
                                        } //VStack
                                        .padding([.top, .leading, .trailing])
                                    } // label
                                }
                            } //ForEach
                        }//HStack
                    }
                    showContentsView(selectedMember)
                    Spacer()
                    //
                }
            }
        }
        //MARK: 컨텐츠가 모달보다 늦게 올라오는 것을 임시로 가려줌으로써 해결
        .overlay{
            Rectangle()
                .foregroundColor(Color("CellColor"))
                .cornerRadius(20)
                .opacity(isLoading ? 1 : 0)
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 30, height: 550)
        .background(
            Rectangle()
                .foregroundColor(Color("CellColor"))
                .cornerRadius(20)
        )
        .onAppear(){
            let current = authManager.firebaseAuth
            let currentUser = current.currentUser?.uid
            selectedMember = currentUser ?? ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                isLoading = false
            }
        }
        .onDisappear(){
            habitManager.currentMateInfos = []
        }
        .offset(y: modalManager.modal.position == .open ? -200 : 0 )
        
    }
    @ViewBuilder
    func showContentsView(_ selectedMember: String) -> some View {
        
        VStack(alignment: .leading) {
            if currentPost.title != "" {
                Text("제목: \(currentPost.title)")
                    .font(.custom("IMHyemin-Bold", size: 22))
                    .foregroundColor(Color("DiaryTitle"))
                    .padding([.top, .bottom])
                HStack{
                    Text(currentPost.content)
                        .font(.custom("IMHyemin-Regular", size: 15))
                        .foregroundColor(Color("DiaryContents"))
                    Spacer()
                }
                Spacer()
            }
            else {
                EmptyCellView(currentContentsType: .post)
            }
        }
        .onAppear(){
            for post in postsForModalView {
                if post.uid == selectedMember {
                    currentPost = post
                }
                else {
                    currentPost = Post(id: "", uid: "", challengeID: "", title: "", content: "", createdAt: Date())
                }
            }
        }
        
    }
    
}

struct PostModalView_Previews: PreviewProvider {
    static var previews: some View {
        PostModalView(postsForModalView: .constant([
            Post(id: "temp_id", uid: "GqAtTh9IMmMuZrFlRqZoZCOrV1l1", challengeID: "7B2BFA02-2E44-49CC-9776-C34A8D078F80", title: "중R", content: "zz", createdAt: Date()) ]))
    }
}
