//
//  AddChallengeMateCellView.swift
//  Hapit
//
//  Created by 김예원 on 2023/02/01.
//

import SwiftUI

struct AddChallengeMateCellView: View {
    
    @State private var isSelectedJelly = 0
    @State private var showBearModal = false
    let bearArray = Jelly.allCases.map({"\($0)"})
    
    @State var mateName: String

    @EnvironmentObject var habitManager: HabitManager
    @State var isChecked: Bool = false
    var body: some View {
        VStack {
            HStack{
                Image(bearArray[isSelectedJelly % 7])
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 40)
                    .background(Circle()
                        .fill(Color(.systemGray6))
                        .frame(width: 60, height: 60))
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                
                Text(mateName)
                    .font(.custom("IMHyemin-Bold", size: 17)).padding(10)
                Spacer()
                
                Button {
                    // 친구 선택
                    isChecked.toggle()
                } label: {
                    Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                        .font(.title)
                        .foregroundColor(isChecked ? .green : .gray)
                    
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing, 5)
                
            }//HStack
            .padding(10)
            .foregroundColor(.black)
            .background(
                .white
            )
            .cornerRadius(15)
            .padding(.horizontal, 20)
            .padding(.bottom, 5)
        }
    }
    
}

struct AddChallengeMateCellView_Previews: PreviewProvider {
    static var previews: some View {
        AddChallengeMateCellView(mateName: "김예원")
    }
}