//
//  MainTabView.swift
//  Halmap
//
//  Created by 전지민 on 2023/03/03.
//

import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject var dataManager: DataManager
    @AppStorage("selectedTeam") var selectedTeam = "Hanwha"
    @StateObject var viewModel = MainTabViewModel()
    
    @EnvironmentObject var audioManager: AudioManager
    @StateObject var mainSongListTabViewModel = MainSongListTabViewModel()
    
    @StateObject var miniPlayerViewModel = MiniPlayerViewModel()
    @GestureState var gestureOffset: CGFloat = 0
    
    let persistence = PersistenceController.shared

    init() {
        Color.setColor(selectedTeam)
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom){
                VStack(spacing: 0) {
                    switch viewModel.state {
                        case .home:
                            MainSongListTabView(viewModel: mainSongListTabViewModel, miniPlayerViewModel: miniPlayerViewModel)
                        case .search:
                            SongSearchView(viewModel: SongSearchViewModel(dataManager: dataManager))
                        case .storage:
                            StorageContentView()
                    }
                    
                    HStack {
                        ForEach(Array(MainTabViewModel.State.allCases.enumerated()), id: \.1.rawValue) { index, state in
                            Button {
                                viewModel.state = state
                            } label: {
                                VStack(spacing: 4) {
                                    Image(state.rawValue)
                                    Text(state.title)
                                }
                                .foregroundColor(viewModel.state == state ? Color.HalmacPoint : Color.customDarkGray)
                            }
                            if index < MainTabViewModel.State.allCases.count - 1 {
                                Spacer()
                            }
                        }
                    }
                    .font(.Halmap.CustomCaptionMedium)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 47)
                    .background(Color.tabBarGray)
                    .shadow(color: Color.customGray, radius: 1)
                    .offset(y: miniPlayerViewModel.hideTabBar ? (15 + 35 + 50) : 0)
                }
                .ignoresSafeArea(.keyboard)
                
                if miniPlayerViewModel.showPlayer{
                    MiniPlayerView()
                        .transition(.move(edge: .bottom))
                        .offset(y: miniPlayerViewModel.offset)
                        .gesture(DragGesture().updating($gestureOffset, body: { (value, state, _) in
                            
                            state = value.translation.height
                        })
                        .onEnded(onEnd(value:)))
                        .padding(.bottom, miniPlayerViewModel.hideTabBar ? 0 : 57)
                }
            }
            .onChange(of: gestureOffset, perform: { value in
                onChanged()
            })
            .environmentObject(miniPlayerViewModel)
        }
        .navigationViewStyle(.stack)
        
    }
    
    func onChanged(){
        if gestureOffset > 0 && !miniPlayerViewModel.isMiniPlayerActivate && miniPlayerViewModel.offset + 200 <= miniPlayerViewModel.height{
            print("player offset >> \(miniPlayerViewModel.offset)")
            print("geture offset >> \(gestureOffset)")
            miniPlayerViewModel.offset = gestureOffset
        }
    }
    
    func onEnd(value: DragGesture.Value){
        withAnimation(.smooth){

            if !miniPlayerViewModel.isMiniPlayerActivate{
                print("Ended player offset >> \(miniPlayerViewModel.offset)")
                print("Ended geture offset >> \(gestureOffset)")
                miniPlayerViewModel.offset = 0
                
                // Closing View...
                if value.translation.height > UIScreen.main.bounds.height / 3{
                    miniPlayerViewModel.hideTabBar = false
                    miniPlayerViewModel.isMiniPlayerActivate = true
                }
                else{
                    miniPlayerViewModel.hideTabBar = true
                    miniPlayerViewModel.isMiniPlayerActivate = false
                }
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
