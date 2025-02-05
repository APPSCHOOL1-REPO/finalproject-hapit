//
//  BadgeGridView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/17.
//

import SwiftUI

struct JellyGridView: View {
    
    @EnvironmentObject var authManager: AuthManager
    
    @State var badgeList: [Badge] = []
    
    //화면을 그리드형식으로 꽉채워줌
    let columns = [
        GridItem(.adaptive(minimum: 100),spacing: 30),
        GridItem(.adaptive(minimum: 100),spacing: 30),
        GridItem(.adaptive(minimum: 100),spacing: 30),
    ]
    
    var body: some View {
        ScrollView{
            VStack{
                
                if authManager.bearBadges.count > 20{
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                        
                        ForEach(authManager.bearBadges, id: \.id) { badge in
                            JellyBadgeView(badge: badge)
                            //.border(.black)
                        }
                    }
                    
                }else{
                    if #available(iOS 15.0, *) {
                        ProgressView("젤리 가져오는 중...")
                            .tint(Color.accentColor)
                            .foregroundColor(Color.accentColor)
                            .font(.custom("IMHyemin-Bold", size: 17))
                            
                    } else {
                        ProgressView("젤리 가져오는 중...")
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.accentColor))
                            .foregroundColor(Color.accentColor)
                            .font(.custom("IMHyemin-Bold", size: 17))
                    }
                }
                
            }
            .padding()
        }
        .task {
            
            authManager.bearBadges.removeAll()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                
                for (badgeName, data) in zip(authManager.newBadges, authManager.bearimagesDatas){
                    
                    let id = UUID().uuidString
                    let newBadge = Badge(id: id, imageName: badgeName, title: showmetheTitle(imageName: badgeName), imageData: data)
                    
                    authManager.bearBadges.append(newBadge)
                }
                
                for _ in 0..<20{
                    
                    let id = UUID().uuidString
                    
                    authManager.bearBadges.append(Badge(id: id, imageName: "", title: "", imageData: Data()))
                }
                
            }
        }
        
    }
    
    func showmetheTitle(imageName: String) -> String{
        
        switch imageName{
            case "bearBlue1":
                return "첫 습관 달성"
            case "bearBlue2":
                return "첫 챌린지!!"
            case "bearGreen":
                return "작심삼일"
            case "bearPurpleB":
                return "첫 친구"
            case "bearRed":
                return "마음이 갈대밭"
            case "bearTurquoise":
                return "처음 가입"
            case "bearYellow":
                return "첫 가입 축하"
            default:
                return "비어 있음"
        }
    }
}

//
//// TODO: 뱃지 존재 여부에 따라 색깔 바꾸기
//if index == 0 {
//    JellyBadgeView(jellyImage: "bearBlue", jellyName: "첫 습관 달성")
//} else if index == 1 {
//    JellyBadgeView(jellyImage: "bearTurquoise", jellyName: "작심삼일")
//} else if index == 2 {
//    JellyBadgeView(jellyImage: "bearYellow", jellyName: "첫 친구")
//} else if index == 3 {
//    JellyBadgeView(jellyImage: "bearGreen", jellyName: "마음이 갈대밭")
//} else {
//    JellyBadgeView(jellyImage: "bearWhite", jellyName: "???")
//}
