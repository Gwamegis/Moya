//
//  NotificationView.swift
//  Halmap
//
//  Created by JeonJimin on 2023/07/09.
//

import SwiftUI

struct NotificationView: View {
    let noti_1 = Notification(
        id: UUID().uuidString,
        icon: "alarm",
        isNews: true,
        title: "모두의 야구 새단장 소식",
        detail: "앱스토어에서 새로 업데이트된 버전을 다운받으세요!",
        list: ["연속 재생이 가능해요.", "재생목록 편집이 가능해요.", "미니 플레이어가 생겼어요."]
    )
    let noti_2 = Notification(
        id: UUID().uuidString,
        icon: "alert",
        isNews: false,
        title: "로딩 지연 발생",
        detail: "일시적으로 사용량이 늘어나며\n메인 화면에 접속하거나 음원을 재생할 때\n로딩이 오래 걸리는 현상이 발생할 수 있습니다.\n사용자분들의 양해를 부탁드립니다.",
        list: []
    )
    let noti_3 = Notification(
        id: UUID().uuidString,
        icon: "alarm",
        isNews: true,
        title: "모두의 야구 새단장 소식",
        detail: "앱스토어에서 새로 업데이트된 버전을 다운받으세요!\n재생바가 생겼어요!\n이제 응원가의 원하는 구간으로 이동이 가능해요.",
        list: []
    )
    
    @State var item: Notification = Notification(id: "", icon: "", isNews: false, title: "", detail: "", list: [])
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("isShouldShowNotification") var isShouldShowNotification = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            Image(item.icon)
                .resizable()
                .foregroundColor(.mainGreen)
                .frame(width: 60, height: 60)
            Text(item.title)
                .font(Font.Halmap.CustomTitleBold)
                .padding(.bottom, 10)
            Text(item.detail)
                .padding(.bottom, 2)
                .foregroundColor(.customDarkGray)
            ForEach(Array(item.list.enumerated()), id: \.offset) { index, list in
                HStack(spacing: 10) {
                    Image("number\(index+1)")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.mainGreen)
                    Text(list)
                        .font(.Halmap.CustomBodyMedium)
                        .foregroundColor(.customDarkGray)
                }
            }
            Spacer()
            if item.isNews {
                HStack(spacing: 10) {
                    Button {
                        print("next")
                        self.presentationMode.wrappedValue.dismiss()
                        self.isShouldShowNotification = false
                    } label: {
                        Text("다음에 할래요")
                            .foregroundColor(.customDarkGray)
                            .modifier(notificationButtonBackground(color: .customGray))
                    }
                    Button {
                        print("now")
                        guard let url = URL(string: "itms-apps://itunes.apple.com/app/6444238142") else { return }
                        UIApplication.shared.open(url)
                        self.isShouldShowNotification = false
                        
                    } label: {
                        Text("업데이트하러 가기")
                            .foregroundColor(.white)
                            .modifier(notificationButtonBackground(color: .mainGreen))
                    }
                }
            } else {
                Button {
                    print("ok")
                    self.presentationMode.wrappedValue.dismiss()
                    self.isShouldShowNotification = false
                } label: {
                    Text("확인")
                        .foregroundColor(.mainGreen)
                        .modifier(notificationButtonBackground(color: .customGray))
                }
            }
            
        }
        .padding(.top, 30)
        .padding(.horizontal, 20)
        .onAppear(){
            item = noti_3
        }
        
    }
}

private struct notificationButtonBackground: ViewModifier {
    let color: Color
    func body(content: Content) -> some View {
        content
            .font(.Halmap.CustomBodyBold)
            .padding(.vertical, 21)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(color)
            )
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
