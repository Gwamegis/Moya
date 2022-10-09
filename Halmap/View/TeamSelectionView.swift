//
//  TeamSelectionView.swift
//  Halmap
//
//  Created by 유정인 on 2022/10/08.
//

import SwiftUI

struct OnBoardingStartView: View {
    @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
    
    @State var startButton: Bool = false
    
    var body: some View {
        if !isFirstLaunching {
            MainView()
        } else {
            TeamSelectionView(isFirstLaunching: $isFirstLaunching)
        }
    }
}

struct TeamSelectionView: View {
    @AppStorage("selectedTeam") var finalSelectedTeam: String = ""
    @Binding var isFirstLaunching: Bool
    
    @State var buttonPressed: [Bool] = [Bool](repeating: false, count: 6)
    @State var selectedTeam: String? = nil
    
    var columns: [GridItem] = Array(repeating: .init(.adaptive(minimum: 200, maximum: .infinity), spacing: 20), count: 2)
    var teamLogo: [String] = ["Doosan", "Lotte", "Hanwha", "Kiwoom", "Kia", "Ssg"]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("응원하는")
                Image("Team")
                    .resizable()
                    .frame(width: 26, height: 36)
                Text("을 \(Text("골라주세요!").font(.Halmap.CustomHeadline))")
            }
            .padding(.bottom, 40)
            .font(.system(size: 20, weight: .medium))
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(teamLogo.indices, id: \.self) { idx in
                    Button {
                        withAnimation {
                            buttonPressed = [Bool](repeating: false, count: 6)
                            if idx > 2 {
                                self.selectedTeam = nil
                            }
                            else {
                                self.buttonPressed[idx].toggle()
                                self.selectedTeam = teamLogo[idx]
                            }
                        }
                    } label: {
                        ZStack {
                            Image(teamLogo[idx])
                                .resizable()
                                .frame(width: 165, height: 158)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(Color.black)
                                .opacity(buttonPressed[idx] ? 0.8 : 0)
                            Image("MyTeam")
                                .resizable()
                                .frame(width: 83, height: 50)
                                .opacity(buttonPressed[idx] ? 1 : 0)
                        }
                    }
                }
            }
            .padding(.bottom, 24)
            Button {
                // TODO: - Userdefault에 선택된 팀 저장하는 코드 추가
                withAnimation {
                    isFirstLaunching.toggle()
                    finalSelectedTeam = selectedTeam ?? "Lotte"
                    Color.setColor(selectedTeam ?? "Lotte")
                }
                print("선택완료")
            } label: {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color.black)
                    .opacity(selectedTeam == nil ? 0.1 : 1)
                    .frame(width: 350, height: 62)
                    .overlay(
                        Text("응원하러 가기")
                            .font(.Halmap.CustomTitleBold)
                            .foregroundColor(.white)
                    )
            }
            .disabled(selectedTeam == nil)
        }
        .padding(.horizontal, 20)
    }
}
