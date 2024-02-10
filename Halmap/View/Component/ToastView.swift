//
//  ToastView.swift
//  Halmap
//
//  Created by JeonJimin on 11/28/23.
//

import SwiftUI

//https://ondrej-kvasnovsky.medium.com/how-to-build-a-simple-toast-message-view-in-swiftui-b2e982340bd
struct Toast: Equatable {
    var team: String
    var message: String
    var duration: Double = 3
    var width: Double = .infinity
}

struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .overlay(
                ZStack {
                    mainToastView()
                        .transition(.move(edge: .bottom))
                        .offset(y: toast != nil ? 0 : 40)
                }.animation(.smooth(duration: 0.2), value: toast)
            )
            .onChange(of: toast) { value in
                showToast()
            }
    }
    
    @ViewBuilder
    func mainToastView() -> some View {
        if let toast {
            VStack {
                ToastView(team: toast.team, message: toast.message) {
                    dismissToast()
                }
            }
        }
    }
    
    private func showToast() {
        guard let toast else { return }
        
        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()
        
        if toast.duration > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                dismissToast()
            }
            
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }
    
    private func dismissToast() {
        withAnimation {
            toast = nil
        }
        workItem?.cancel()
        workItem = nil
    }
}

struct ToastView: View {
    let team: String
    var message = "재생 목록의 처음으로 돌아갑니다."
    var width = CGFloat.infinity
    var onCancelTapped: (() -> Void)
    var body: some View {
        HStack(alignment: .center, spacing: 18) {
            Image(systemName: "text.insert")
            Text(message)
                .font(Font.Halmap.CustomBodyBold)
        }
        .foregroundStyle(Color("\(team)Background"))
        .padding(EdgeInsets(top: 17, leading: 28, bottom: 17, trailing: 28))
        .background(Color.customGray)
        .cornerRadius(10)
        .onTapGesture {
            onCancelTapped()
        }
    }
}

extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}
