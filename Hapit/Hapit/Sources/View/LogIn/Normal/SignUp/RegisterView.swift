//
//  SignUpView.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI

struct RegisterView: View {
    
    @State private var email: String = ""
    @State private var mailDuplicated: Bool = false
    @State private var emailTmp: String = ""
    
    var dupEmail: Bool {
        return email == emailTmp
    }
    
    @State private var pw: String = ""
    @State private var showPw: Bool = false
    
    @State private var pwCheck: String = ""
    @State private var showPwCheck: Bool = false
    
    @State private var nickName: String = ""
    @State private var nameCheck: Bool = false
    @State private var nameTmp: String = ""
    
    var dupName: Bool {
        return nickName == nameTmp
    }
    
    @State private var isSecuredPassword: Bool = true
    @State private var isSecuredCheckPassword: Bool = true
    
    @FocusState private var emailFocusField: Bool
    @FocusState private var pwFocusField: Bool
    @FocusState private var pwCheckFocusField: Bool
    @FocusState private var nickNameFocusField: Bool
    
    @State private var canGoNext: Bool = false
    @State private var isClicked: Bool = false
    
    @EnvironmentObject var normalSignInManager: NormalSignInManager
    
    let deviceHeight = UIScreen.main.bounds.height
    
    var fontSize: CGFloat {
        if deviceHeight < CGFloat(700.0) {
            return 14
        } else if deviceHeight >= CGFloat(700.0) && deviceHeight < CGFloat(820.0) {
            return 15
        } else if deviceHeight >= CGFloat(820.0) && deviceHeight < CGFloat(860.0) {
            return 16
        } else {
            return 17
        }
    }
    
    var errorFontSize: CGFloat {
        if deviceHeight < CGFloat(700.0) {
            return 10
        } else if deviceHeight >= CGFloat(700.0) && deviceHeight < CGFloat(820.0) {
            return 11
        } else if deviceHeight >= CGFloat(820.0) && deviceHeight < CGFloat(860.0) {
            return 12
        } else {
            return 13
        }
    }
    
    var frameSize: CGFloat {
        if deviceHeight < CGFloat(700.0) {
            return 25
        } else if deviceHeight >= CGFloat(700.0) && deviceHeight < CGFloat(820.0) {
            return 26
        } else if deviceHeight >= CGFloat(820.0) && deviceHeight < CGFloat(860.0) {
            return 27
        } else {
            return 28
        }
    }

    var stackSpacing: CGFloat {
        if deviceHeight < CGFloat(700.0) {
            return 10
        } else if deviceHeight >= CGFloat(700.0) && deviceHeight < CGFloat(820.0) {
            return 12
        } else if deviceHeight >= CGFloat(820.0) && deviceHeight < CGFloat(860.0) {
            return 14
        } else {
            return 16
        }
    }
    
    //비율 분포: 1/6.6 - 1/50 - 1/50
    var body: some View {
        GeometryReader { geo in
            VStack() {
                Group {
                    // 1. iOS 버전을 기준으로 StepBar 분기처리
                    // 2. 분기 내에서 디바이스 높이를 기준으로 GuideText 분기처리
                    if #available(iOS 16.0, *) {
                        if deviceHeight < CGFloat(700.0) {
                            StepBar_16(step: 1, frameSize: 23, fontSize: 13)
                            RegisterGuideText(fontSize: 23)
                                .padding(.top, -30)
                        } else if deviceHeight >= CGFloat(700.0) && deviceHeight < CGFloat(820.0) {
                            StepBar_16(step: 1, frameSize: 25, fontSize: 15)
                            RegisterGuideText(fontSize: 25)
                                .padding(.top, -30)
                        } else if deviceHeight >= CGFloat(820.0) && deviceHeight < CGFloat(860.0) {
                            StepBar_16(step: 1, frameSize: 28, fontSize: 18)
                            RegisterGuideText(fontSize: 30)
                                .padding(.top, -30)
                        } else {
                            StepBar_16(step: 1, frameSize: 30, fontSize: 20)
                            RegisterGuideText(fontSize: 34)
                                .padding(.top, -30)
                        }
                    } else {
                        if deviceHeight < CGFloat(700.0) {
                            StepBar_15(step: 1, frameSize: 23, fontSize: 13)
                            RegisterGuideText(fontSize: 23)
                                .padding(.top, -30)
                        } else if deviceHeight >= CGFloat(700.0) && deviceHeight < CGFloat(820.0) {
                            StepBar_15(step: 1, frameSize: 25, fontSize: 15)
                            RegisterGuideText(fontSize: 25)
                                .padding(.top, -30)
                        } else if deviceHeight >= CGFloat(820.0) && deviceHeight < CGFloat(860.0) {
                            StepBar_15(step: 1, frameSize: 28, fontSize: 18)
                            RegisterGuideText(fontSize: 30)
                                .padding(.top, -30)
                        } else {
                            StepBar_15(step: 1, frameSize: 30, fontSize: 20)
                            RegisterGuideText(fontSize: 34)
                                .padding(.top, -30)
                        }
                    }
                }
                .padding(.bottom, geo.size.height / 16)
                
                VStack(spacing: stackSpacing) {
                    VStack(alignment: .leading) {
                        HStack {
                            TextField("이메일을 입력해주세요.", text: $email)
                                .font(.custom("IMHyemin-Bold", size: fontSize))
                                .keyboardType(.emailAddress)
                                .focused($emailFocusField)
                                .modifier(ClearTextFieldModifier())
                                .shakeEffect(trigger: mailDuplicated)
                            
                            // email이 비어있지 않으면서, 형식이 올바를 때 체크 아이콘 띄움.
                            if !email.isEmpty && checkEmailType(string: email) {
                                Image(systemName: "checkmark.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: fontSize)
                                    .foregroundColor(.green)
                            }
                        } // HStack - TextField, Secured Image, Check Image
                        .frame(height: frameSize) // TextField가 있는 HStack의 height 고정 <- 아이콘 크기 변경 방지
                        
                        Rectangle()
                            .modifier(TextFieldUnderLineRectangleModifier(stateTyping: emailFocusField))
                        
                        //이메일 형식은 맞는데, 중복판정받았고, email이 중복판정받은 email로 쓰여있을 때
                        if !email.isEmpty && checkEmailType(string: email) && mailDuplicated && dupEmail {
                            HStack(alignment: .center, spacing: 3) {
                                Image(systemName: "exclamationmark.circle")
                                Text("이미 사용중인 이메일입니다.")
                            }
                            .font(.custom("IMHyemin-Bold", size: errorFontSize))
                            .foregroundColor(.red)
                            .frame(height: errorFontSize)
                        } else if !email.isEmpty && !checkEmailType(string: email) {
                            HStack(alignment: .center, spacing: 5) {
                                Image(systemName: "exclamationmark.circle")
                                Text("올바른 이메일 형식이 아닙니다.")
                            }
                            .font(.custom("IMHyemin-Bold", size: errorFontSize))
                            .foregroundColor(.red)
                            .frame(height: errorFontSize)
                        } else {
                            Text("l") // TextField 자리 고정
                                .font(.custom("IMHyemin-Bold", size: errorFontSize))
                                .foregroundColor(.clear)
                                .frame(height: errorFontSize)
                        }
                    }
                    
                    // MARK: 비밀번호 입력
                    VStack(alignment: .leading) {
                        HStack {
                            // 비밀번호 숨김 아이콘일 때
                            if isSecuredPassword {
                                SecureField("비밀번호를 입력해주세요.", text: $pw)
                                    .font(.custom("IMHyemin-Bold", size: fontSize))
                                    .textContentType(.newPassword)
                                    .textContentType(.oneTimeCode)
                                    .focused($pwFocusField) // 커서가 올라가있을 때 상태를 저장.
                                    .modifier(ClearTextFieldModifier())
                                    //.padding(.bottom, 0.2)
                            } else { // 비밀번호 보임 아이콘일 때
                                TextField("비밀번호를 입력해주세요.", text: $pw)
                                    .font(.custom("IMHyemin-Bold", size: fontSize))
                                    .focused($pwFocusField)
                                    .modifier(ClearTextFieldModifier())
                                    //.padding(.bottom, 0.2)
                            }
                            
                            Button(action: {
                                // 비밀번호 보임/숨김을 설정함.
                                isSecuredPassword.toggle()
                            }) {
                                Image(systemName: self.isSecuredPassword ? "eye.slash" : "eye")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: fontSize)
                                    .accentColor(Color("GrayFontColor"))
                            }
                            // password가 비어있지 않으면서, 6자리 이상일 때 체크 아이콘 띄움.
                            if !pw.isEmpty && checkPasswordType(password: pw) {
                                Image(systemName: "checkmark.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: fontSize)
                                    .foregroundColor(.green)
                            }
                        } // HStack - TextField, Secured Image, Check Image
                        .frame(height: frameSize) // TextField가 있는 HStack의 height 고정 <- 아이콘 크기 변경 방지
                        
                        Rectangle()
                            .modifier(TextFieldUnderLineRectangleModifier(stateTyping: pwFocusField))
                        
                        // 비밀번호 형식이 아닐 경우 경고 메시지
                        if !pw.isEmpty && !checkPasswordType(password: pw) {
                            HStack(alignment: .center, spacing: 5) {
                                Image(systemName: "exclamationmark.circle")
                                Text("영문, 숫자, 특수문자를 포함하여 8~20자로 작성해주세요.")
                            }
                            .foregroundColor(.red)
                            .font(.custom("IMHyemin-Bold", size: errorFontSize))
                            .frame(height: errorFontSize)
                        }
                        else {
                            Text("") // TextField 자리 고정
                                .font(.custom("IMHyemin-Bold", size: errorFontSize))
                                .frame(height: errorFontSize)
                        }
                    } // VStack - HStack과 밑줄 Rectangle
                    //.frame(height: frameSize)
                    
                    // MARK: 비밀번호 확인 입력
                    VStack(alignment: .leading) {
                        HStack {
                            // 비밀번호 숨김 아이콘일 때
                            if isSecuredCheckPassword {
                                SecureField("비밀번호를 다시 입력해주세요.", text: $pwCheck)
                                    .font(.custom("IMHyemin-Bold", size: fontSize))
                                    .textContentType(.newPassword)
                                    .textContentType(.oneTimeCode)
                                    .focused($pwCheckFocusField) // 커서가 올라가있을 때 상태를 저장.
                                    .modifier(ClearTextFieldModifier())
                                    //.padding(.bottom, 0.2)
                            } else { // 비밀번호 보임 아이콘일 때
                                TextField("비밀번호를 다시 입력해주세요", text: $pwCheck)
                                    .font(.custom("IMHyemin-Bold", size: fontSize))
                                    .focused($pwCheckFocusField)
                                    .modifier(ClearTextFieldModifier())
                                    //.padding(.bottom, 0.2)
                            }
                            
                            Button(action: {
                                // 비밀번호 보임/숨김을 설정함.
                                isSecuredCheckPassword.toggle()
                            }) {
                                Image(systemName: self.isSecuredCheckPassword ? "eye.slash" : "eye")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: fontSize)
                                    .accentColor(Color("GrayFontColor"))
                            }
                            // password가 비어있지 않으면서, 6자리 이상일 때 체크 아이콘 띄움.
                            if !pwCheck.isEmpty && checkPasswordType(password: pwCheck) {
                                Image(systemName: "checkmark.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: fontSize)
                                    .foregroundColor(.green)
                            }
                        } // HStack - TextField, Secured Image, Check Image
                        .frame(height: frameSize) // TextField가 있는 HStack의 height 고정 <- 아이콘 크기 변경 방지
                        
                        Rectangle()
                            .modifier(TextFieldUnderLineRectangleModifier(stateTyping: pwCheckFocusField))
                        
                        // 비밀번호 형식이 아닐 경우 경고 메시지
                        if pw != pwCheck && pw != "" && pwCheck != "" {
                            HStack(alignment: .center, spacing: 5) {
                                Image(systemName: "exclamationmark.circle")
                                Text("비밀번호가 일치하지 않습니다")
                            }
                            .foregroundColor(.red)
                            .font(.custom("IMHyemin-Bold", size: errorFontSize))
                            .frame(height: errorFontSize)
                        } else if pw != pwCheck && pw == "" {
                            HStack(alignment: .center, spacing: 5) {
                                Image(systemName: "exclamationmark.circle")
                                Text("비밀번호를 먼저 입력해주세요")
                            }
                            .foregroundColor(.red)
                            .font(.custom("IMHyemin-Bold", size: errorFontSize))
                            .frame(height: errorFontSize)
                        } else {
                            Text("") // TextField 자리 고정
                                .font(.custom("IMHyemin-Bold", size: errorFontSize))
                                .frame(height: errorFontSize)
                        }
                    } // VStack - HStack과 밑줄 Rectangle
                    //.frame(height: frameSize)
                    
                    // MARK: 닉네임 입력
                    VStack(alignment: .leading) {
                        HStack {
                            TextField("닉네임을 입력해주세요.", text: $nickName)
                                .keyboardType(.namePhonePad)
                                .font(.custom("IMHyemin-Bold", size: fontSize))
                                .focused($nickNameFocusField)
                                .modifier(ClearTextFieldModifier())
                                .shakeEffect(trigger: nameCheck)
                            
                            // email이 비어있지 않으면서, 형식이 올바를 때 체크 아이콘 띄움.
                            if !nickName.isEmpty && nickName.count >= 2 {
                                Image(systemName: "checkmark.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: fontSize)
                                    .foregroundColor(.green)
                            }
                            
                        } // HStack - TextField, Secured Image, Check Image
                        .frame(height: frameSize) // TextField가 있는 HStack의 height 고정 <- 아이콘 크기 변경 방지
                        
                        Rectangle()
                            .modifier(TextFieldUnderLineRectangleModifier(stateTyping: nickNameFocusField))
                        
                        if nickName != "" && nickName.count >= 2 && nameCheck && dupName {
                            HStack(alignment: .center, spacing: 5) {
                                Image(systemName: "exclamationmark.circle")
                                Text("이미 사용중인 닉네임입니다.")
                            }
                            .foregroundColor(.red)
                            .font(.custom("IMHyemin-Bold", size: errorFontSize))
                            .frame(height: errorFontSize)
                        } else if nickName != "" && nickName.count < 2 {
                            HStack(alignment: .center, spacing: 5) {
                                Image(systemName: "exclamationmark.circle")
                                Text("닉네임을 2글자 이상 입력해주세요")
                            }
                            .foregroundColor(.red)
                            .font(.custom("IMHyemin-Bold", size: errorFontSize))
                            .frame(height: errorFontSize)
                        } else {
                            Text("")
                                .font(.custom("IMHyemin-Bold", size: errorFontSize))
                                .frame(height: errorFontSize)
                        }
                    }
                    //.frame(height: frameSize)
                }
                .padding(.bottom, geo.size.height / 50)
                
                // MARK: 완료 버튼
                // Fallback on earlier versions
                
                Spacer()
                
                NavigationLink(destination: ToSView(email: $email, pw: $pw, nickName: $nickName), isActive: $canGoNext) {
                    Button(action: {
                        Task {
                            do {
                                let target = try await normalSignInManager.isEmailDuplicated(email: email)
                                mailDuplicated = target
                            } catch {
                                throw(error)
                            }
                            
                            do {
                                let target = try await normalSignInManager.isNicknameDuplicated(nickName: nickName)
                                nameCheck = target
                            } catch {
                                throw(error)
                            }
                            //False면 사용가능, true면 중복이라 사용불가
                            
                            //이메일 중복인경우
                            if mailDuplicated {
                                emailTmp = email
                                emailFocusField = true
                            }
                            
                            //닉네임 중복인 경우
                            if nameCheck {
                                nameTmp = nickName
                                if !mailDuplicated {
                                    nickNameFocusField = true
                                }
                            }
                            canGoNext = isDuplicated()
                        }
                    }) {
                        Text("완료")
                            .font(.custom("IMHyemin-Bold", size: fontSize))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(isOk() ? Color("GrayFontColor") : Color.accentColor)
                            }
                    }
                }
                .disabled(isOk())
                .padding(.vertical, geo.size.height / 50)
            }
            .ignoresSafeArea(.keyboard)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .padding(.horizontal, 20)
        }
    }
    
    // 이메일 유효성 검증
    func checkEmailType(string: String) -> Bool {
        let emailFormula = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        
        return NSPredicate(format: "SELF MATCHES %@", emailFormula).evaluate(with: string)
    }
    
    //비밀번호 유효성 검증
    func checkPasswordType(password: String) -> Bool {
        let passwordFormula = "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,20}$"
        
        return password.range(of: passwordFormula, options: .regularExpression) != nil
    }
    
    //다음단계로 넘어갈 수 있는지 검증해주는 함수
    func isOk() -> Bool {
        if pw == pwCheck && checkPasswordType(password: pw) && checkEmailType(string: email) && nickName != "" {
            return false
        } else {
            return true
        }
    }
    
    //이메일과 닉네임이 중복되지 않았는가를 검증해주어 -> 완료버튼 활성화 결정해주는 함수
    func isDuplicated() -> Bool {
        //메일 닉네임 둘 중 하나가 중복이면 navigationDestination 비활성화
        if mailDuplicated || nameCheck {
            return false
        } else {
            return true
        }
    }
}

struct ClearTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
    }
}

// MARK: - Modifier : TextField 아래 밑줄을 표현하기 위한 Rectangle 속성
struct TextFieldUnderLineRectangleModifier: ViewModifier {
    let deviceHeight = UIScreen.main.bounds.height
    var lineHeight: CGFloat {
        if deviceHeight < CGFloat(700.0) {
            return 1.5
        } else {
            return 2.0
        }
    }
    
    let stateTyping: Bool
    var padding: CGFloat = 20
    func body(content: Content) -> some View {
        content
            .frame(height: lineHeight)
            .foregroundColor(stateTyping ? .accentColor : Color("GrayFontColor"))

    }
}
