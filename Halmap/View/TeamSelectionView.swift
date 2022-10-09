//
//  TeamSelectionView.swift
//  Halmap
//
//  Created by 유정인 on 2022/10/08.
//

import SwiftUI

struct TeamSelectionView: View {
    @State var buttonPressed: Bool = false
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
                ForEach(teamLogo, id: \.self) { team in
                    Button {
                        // TODO: - 팀 선택시 효과 추가
                        if self.buttonPressed {
                            self.buttonPressed = false
                        } else {
                            self.buttonPressed = true
                            self.selectedTeam = team
                        }
                        print(selectedTeam)
                    } label: {
                        ZStack {
                            Image(team)
                                .resizable()
                                .frame(width: 165, height: 158)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(Color.black)
                                .opacity(buttonPressed ? 0.7 : 0)
                            Image("MyTeam")
                                .resizable()
                                .frame(width: 83, height: 50)
                                .opacity(buttonPressed ? 1 : 0)
                        }
                    }
                }
            }
            .padding(.bottom, 24)
            Button {
                // TODO: - Userdefault에 선택된 팀 저장하는 코드 추가
            } label: {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 350, height: 62)
            }

        }
        .padding(.horizontal, 20)
    }
}

struct TeamSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        TeamSelectionView()
    }
}
