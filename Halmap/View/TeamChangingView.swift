//
//  TeamSelectionView.swift
//  Halmap
//
//  Created by 유정인 on 2022/10/08.
//

import SwiftUI

struct TeamChangingView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var changedTeam: String
    @State var buttonPressed: [Bool] = [Bool](repeating: false, count: 10)
    @State var selectedTeam: String? = nil
    @State var originSelectedTeam: String = (UserDefaults.standard.string(forKey: "selectedTeam") ?? "error")
    
    var columns: [GridItem] = Array(repeating: .init(.adaptive(minimum: 200, maximum: .infinity), spacing: 20), count: 2)
    var teamLogo = TeamName.allCases

    var body: some View {
        VStack(alignment: .leading) {
            Text("어느 팀을 응원하시나요?")
                .font(.Halmap.CustomTitleBold)
                .padding(.top, 20)
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(teamLogo.indices, id: \.self) { idx in
                    Button {
                        withAnimation {
                            buttonPressed = [Bool](repeating: false, count: 10)
                            self.buttonPressed[idx].toggle()
                            self.selectedTeam = teamLogo[idx].rawValue
                        }
                    } label: {
                        ZStack {
                            Image(teamLogo[idx].rawValue)
                                .resizable()
                                .frame(width: UIScreen.getWidth(170), height: UIScreen.getHeight(108))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(Color.black)
                                .opacity(buttonPressed[idx] ? 0.8 : 0)
                            Image(systemName: "checkmark")
                                .resizable()
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: UIScreen.getWidth(29), height: UIScreen.getHeight(31))
                                .opacity(buttonPressed[idx] ? 1 : 0)
                        }
                    }
                }
            }
            .padding(.bottom, 24)
            .padding(.horizontal, 5)
            
            Button {
                UserDefaults.standard.set(selectedTeam, forKey: "selectedTeam")
                withAnimation {
                    self.presentationMode.wrappedValue.dismiss()
                    changedTeam = selectedTeam ?? "Hanwha"
                }
                print("선택완료")
            } label: {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color.black)
                    .opacity(selectedTeam == nil ? 0.1 : 1)
                    .frame(width: UIScreen.getWidth(350), height: UIScreen.getHeight(62))
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
