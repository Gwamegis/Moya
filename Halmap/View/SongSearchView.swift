//
//  SongSearchView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

struct SongSearchView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @ObservedObject var dataManager = DataManager()
    
    @GestureState private var dragOffset = CGSize.zero
    @FocusState private var isFocused: Bool?
    
    @State private var searchText = ""
//    @State private var autoComplete = [Music]()
    @State private var autoComplete = [Song]()
    
    var body: some View {
        
        VStack {
            
            navigationView
            
            resultView
            
            Spacer()
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity)
        .navigationBarBackButtonHidden(true)
        .onAppear { UIApplication.shared.hideKeyboard() }
    }
    
    
    // MARK: Search Bar
    var searchBar: some View {
        HStack {
            
            TextField("\(Image(systemName: "magnifyingglass")) 검색", text: $searchText)
                .disableAutocorrection(true)
                .foregroundColor(searchText.isEmpty ? Color(.systemGray) : .black)
                .onChange(of: searchText) { _ in
                    // TODO: 수정 필요
//                    didChangedSearchText()
                }
                .focused($isFocused, equals: true)
                .task {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isFocused = true
                    }
                }
            
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
                        .foregroundColor(Color(.systemGray))
                        .padding(30)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
            } else {
                
                List {
                    ForEach(autoComplete.indices, id: \.self) { index in
                        NavigationLink(destination: SongInformationView(song: autoComplete[index])) {
                            HStack {
                                
                                Image(systemName: "magnifyingglass")
                                Text(autoComplete[index].title)
                            }
                            .padding(.horizontal, 20)
                            .frame(height: 45)
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                
            }
        }
        
    }
    
    var navigationView: some View {
        ZStack {
            Rectangle()
                .frame(height: 120)
                .foregroundColor(.HalmacBackground)
            
            HStack(spacing: 17) {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.white)
                    .onTapGesture {
                        self.mode.wrappedValue.dismiss()
                    }
                
                searchBar
            }
            .padding(.horizontal, 20)
            .padding(.top, 50)
        }
    }
    
//    private func didChangedSearchText() {
//        
//        autoComplete = []
//        
//        for data in dataManager.playerSongs {
//            if data.title.contains(searchText.lowercased()) {
//                let music = Music(songTitle: data.title, lyric: data.lyrics)
//                autoComplete.append(music)
//            }
//        }
//        
//        for data in dataManager.teamSongs {
//            if data.title.contains(searchText.lowercased()) {
//                let music = Music( songTitle: data.title, lyric: data.lyrics)
//                autoComplete.append(music)
//            }
//        }
//        
//    }
    
}


// MARK: Previews
struct SongSearchView_Previews: PreviewProvider {
    static var previews: some View {
        SongSearchView()
    }
}
