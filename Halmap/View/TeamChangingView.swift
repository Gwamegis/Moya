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
    @State var buttonPressed: [Bool] = [Bool](repeating: false, count: 6)
    @State var selectedTeam: String? = nil
    @State var originSelectedTeam: String = (UserDefaults.standard.string(forKey: "selectedTeam") ?? "error")
    
    var columns: [GridItem] = Array(repeating: .init(.adaptive(minimum: 200, maximum: .infinity), spacing: 20), count: 2)
    var teamLogo: [String] = ["Doosan", "Lotte", "Hanwha", "Kiwoom", "Kia", "Ssg"]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("응원하는")
                Image("Team")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.getWidth(26), height: UIScreen.getHeight(36), alignment: .top)
                Text("을 \(Text("골라주세요!").font(.Halmap.CustomHeadline))")
            }
            .padding(.bottom, 40)
            .font(.system(size: 20, weight: .medium))
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(teamLogo.indices, id: \.self) { idx in
                    Button {
                        withAnimation {
                            buttonPressed = [Bool](repeating: false, count: 6)
                            self.buttonPressed[idx].toggle()
                            self.selectedTeam = teamLogo[idx]
                        }
                    } label: {
                        ZStack {
                            Image(teamLogo[idx])
                                .resizable()
                                .frame(width: UIScreen.getWidth(165), height: UIScreen.getHeight(158))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(Color.black)
                                .opacity(buttonPressed[idx] ? 0.8 : 0)
                            Image("MyTeam")
                                .resizable()
                                .frame(width: UIScreen.getWidth(83), height: UIScreen.getHeight(50))
                                .opacity(buttonPressed[idx] ? 1 : 0)
                        }
                    }
                }
            }
            .padding(.bottom, 24)
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
