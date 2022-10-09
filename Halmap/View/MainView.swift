//
//  MainView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var dataManager = DataManager()
    @State private var showingStadiumSheet: Bool = false
    @State var index = 0

    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Image("LotteMainTop")
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
                
                TabView(selection: $index) {
                    List{
                        ForEach(dataManager.playerList.indices, id: \.self) { player in
                            Text("\(dataManager.playerList[player].playerName)")
                        }
                    }
                    .listStyle(.plain)
                    .listRowSeparatorTint(Color.gray.opacity(0.2))
                    .tag(0)
                    
                    List{
                        ForEach(dataManager.teamSongList.indices, id: \.self) { teams in
                            Text("\(dataManager.teamSongList[teams].songName)")
                        }
                    }
                    .listStyle(.plain)
                    .listRowSeparatorTint(Color.gray.opacity(0.2))
                    .tag(1)
                    
                }
                .padding(.top, 65)
                
                TabBarView(currentTab: $index)
                    .padding(.top, 28)
            }
            .navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup (placement: .navigationBarLeading) {
                    Button {
                        // print("button click")
                        self.showingStadiumSheet.toggle()
                    } label: {
                        Image(systemName: "square.grid.2x2.fill").foregroundColor(.white)
                    }
                    .padding(.leading, 160)
                    .sheet(isPresented: $showingStadiumSheet) {
                        StadiumListSheetView()
                    }
                }
                
                ToolbarItemGroup (placement: .navigationBarTrailing) {
                    Button {
                        print("button click")
                    } label: {
                        Image(systemName: "map.fill").foregroundColor(.white)
                    }
                    Button {
                        print("button click")
                    } label: {
                        Image(systemName: "magnifyingglass").foregroundColor(.white)
                    }
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
