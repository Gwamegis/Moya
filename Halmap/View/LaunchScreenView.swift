//
//  LaunchScreenView.swift
//  Halmap
//
//  Created by JeonJimin on 2023/07/30.
//

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        ZStack(alignment: .center) {
            Color.clear
            Image("LaunchScreenLogo")
                .resizable()
                .frame(width: 115, height: 126)
        }
        .ignoresSafeArea()
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
