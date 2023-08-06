//
//  NotificationView.swift
//  Halmap
//
//  Created by JeonJimin on 2023/07/09.
//

import SwiftUI
import FirebaseFirestoreSwift

enum NotificationType {
    case traffic
    case version
    case event
}
struct NotificationView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataManager: DataManager
    
    @AppStorage("isShouldShowNotification") var isShouldShowNotification = false
    @AppStorage("isShouldShowTraffic") var isShouldShowTraffic = false
    @AppStorage("latestVersion") var latestVersion = ""
    @AppStorage("latestTrafficDate") var latestTrafficDate = ""
    
    @State var item: Notification = Notification.init()
    @State var remoteDate = ""
    
    let type: NotificationType
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 20) {
                //icon
                Image(item.icon)
                    .resizable()
                    .foregroundColor(.mainGreen)
                    .frame(width: 60, height: 60)
                //title
                Text(item.title)
                    .font(.Halmap.CustomTitleBold)
                    .padding(.bottom, 10)
                //detail (description)
                Text(item.detail.replacingOccurrences(of: "\\n", with: "\n"))
                    .padding(.bottom, 2)
                    .font(.Halmap.CustomBodyMedium)
                    .lineSpacing(10)
                    .foregroundColor(.customDarkGray)
                //feature list
                VStack(alignment: .leading, spacing: 4) {
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
                }
                Spacer()
                //button
                if type == .version {
                    HStack(spacing: 10) {
                        Button {
                            self.presentationMode.wrappedValue.dismiss()
                            self.isShouldShowNotification = false
                            self.latestVersion = item.version
                        } label: {
                            Text("다음에 할래요")
                                .foregroundColor(.customDarkGray)
                                .modifier(notificationButtonBackground(color: .customGray))
                        }
                        Button {
                            guard let url = URL(string: "itms-apps://itunes.apple.com/app/6444238142") else { return }
                            UIApplication.shared.open(url)
                            self.isShouldShowNotification = false
                            self.latestVersion = item.version
                            
                        } label: {
                            Text("업데이트하러 가기")
                                .foregroundColor(.white)
                                .modifier(notificationButtonBackground(color: .mainGreen))
                        }
                    }
                } else if type == .traffic {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                        self.isShouldShowTraffic = false
                        
                        latestTrafficDate = remoteDate
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
        .onAppear() {
            switch type {
            case .version:
                let notifications = dataManager.versionNotification
                if !notifications.isEmpty {
                    self.item = notifications[0]
                }
                break
            case .traffic:
                let notifications = dataManager.trafficNotification
                if !notifications.isEmpty {
                    self.item = Notification(title: notifications[0].title, detail: notifications[0].description)
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YYYYMMdd"
                    self.remoteDate = dateFormatter.string(from: notifications[0].date)
                }
                break
            case .event:
                break
            }
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
