//
//  NotificationView.swift
//  Halmap
//
//  Created by JeonJimin on 2023/07/09.
//

import SwiftUI
import FirebaseFirestoreSwift

struct NotificationView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("isShouldShowNotification") var isShouldShowNotification = false
    @FirestoreQuery(collectionPath: "IOSVersion") var item: [Notification]
    
    var body: some View {
        
        if item.count > 0 {
            let _ = print(item)
            VStack(alignment: .leading, spacing: 20) {
                Image(item[0].icon)
                    .resizable()
                    .foregroundColor(.mainGreen)
                    .frame(width: 60, height: 60)
                Text(item[0].title)
                    .font(.Halmap.CustomTitleBold)
                    .padding(.bottom, 10)
                Text(item[0].detail.replacingOccurrences(of: "\\n", with: "\n"))
                    .padding(.bottom, 2)
                    .font(.Halmap.CustomBodyMedium)
                    .lineSpacing(10)
                    .foregroundColor(.customDarkGray)
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(item[0].list.enumerated()), id: \.offset) { index, list in
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
                }
                Spacer()
                if item[0].isNews {
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
            .padding(.bottom, 26)
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
