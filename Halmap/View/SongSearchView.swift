//
//  SongSearchView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

struct SongSearchView: View {
    
    @State var selectedTeam: String = (UserDefaults.standard.string(forKey: "selectedTeam") ?? "Hanwha")
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @ObservedObject var dataManager = DataManager()
    
    @GestureState private var dragOffset = CGSize.zero
    @FocusState private var isFocused: Bool
    
    @State private var searchText = ""
    @State private var autoComplete = [Song]()
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            navigationView
            
            resultView
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
        .frame(maxWidth: .infinity)
        .background(Color.systemBackground)
        .navigationBarBackButtonHidden(true)
        .onAppear { UIApplication.shared.hideKeyboard() }
    }
    
    
    // MARK: Search Bar
    var searchBar: some View {
        HStack {
            
            TextField("\(Image(systemName: "magnifyingglass")) 검색", text: $searchText)
                .accentColor(.black)
                .disableAutocorrection(true)
                .onChange(of: searchText) { _ in
                    // TODO: 수정 필요
                    didChangedSearchText()
                }
                .focused($isFocused)
                .background(Color.customGray)
            
            if !searchText.isEmpty {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.medium)
                    .padding(3)
                    .foregroundColor(Color(.systemGray2))
                    .onTapGesture {
                        withAnimation {
                            self.searchText = ""
                        }
                    }
            }
        }
        .frame(height: 40)
        .padding(.horizontal, 20)
        .background(Color(.systemGray6))
        .cornerRadius(30)
    }
    
    
    // MARK: Result View
    var resultView: some View {
        
        VStack {
            if searchText.isEmpty {
                VStack {
                    Text("선수 이름, 응원가를 검색해주세요")
                        .foregroundColor(Color.customDarkGray)
                        .padding(30)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else {
                
                List {
                    ForEach(autoComplete.indices, id: \.self) { index in
                        NavigationLink(destination: SongInformationView(song: autoComplete[index])) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                Text(autoComplete[index].title)
                            }
                            .font(Font.Halmap.CustomBodyMedium)
                            .foregroundColor(Color.black)
                            .frame(height: 45)
                        }
                        .listRowBackground(Color(UIColor.clear))
                        .listRowInsets((EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)))
                        .listRowSeparatorTint(Color.customGray)
                    }
                }
                .padding(.horizontal, 20)
                .listStyle(.plain)
                .padding(.top, 10)
                
            }
        }
        .background(Color.systemBackground)
        
    }
    
    var navigationView: some View {
        ZStack {
            Rectangle()
                .frame(height: 120)
                .foregroundColor(Color.HalmacSub)
            
            HStack(spacing: 17) {
//                Image(systemName: "chevron.left")
//                    .foregroundColor(Color.white)
//                    .onTapGesture {
//                        self.mode.wrappedValue.dismiss()
//                    }
                
                searchBar
                
                if !searchText.isEmpty {
                    Button {
                        isFocused = false
                    } label: {
                        Text("취소")
                    }
                    .foregroundColor(Color.white)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 50)
        }
    }
    
    private func didChangedSearchText() {
        
        autoComplete = []

        for data in dataManager.playerSongs {
            if data.title.contains(searchText.lowercased()) {
                let music = Song(id: data.id, type: data.type, title: data.title, lyrics: data.lyrics, info: data.info, url: data.url)
                autoComplete.append(music)
            }
        }
        
        for data in dataManager.teamSongs {
            if data.title.contains(searchText.lowercased()) {
                let music = Song(id: data.id, type: data.type, title: data.title, lyrics: data.lyrics, info: data.info, url: data.url)
                autoComplete.append(music)
            }
        }
        
    }
    
}


// MARK: Previews
struct SongSearchView_Previews: PreviewProvider {
    static var previews: some View {
        SongSearchView()
    }
}
