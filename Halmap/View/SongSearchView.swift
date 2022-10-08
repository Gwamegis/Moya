//
//  SongSearchView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

struct SongSearchView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @GestureState private var dragOffset = CGSize.zero
    
    @State var searchText = ""
    @State var autoComplete = [String]()
    @State var testData = ["안녕하세요", "두산", "이지원", "이쏘이", "정인이", "티나", "안나", "엘리", "예니", "dkssud"]
    
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                navigationView
                
                resultView
                    .gesture(DragGesture().updating($dragOffset, body: { value, state, transaction in
                        if value.startLocation.x < 20 && value.translation.width > 100 {
                            self.mode.wrappedValue.dismiss()
                        }
                    }))
                
                Spacer()
                
            }
            .ignoresSafeArea()
            .frame(maxWidth: .infinity)
        }
        .navigationBarBackButtonHidden(true)
        .gesture(DragGesture().updating($dragOffset, body: { value, state, transaction in
            if value.startLocation.x < 20 && value.translation.width > 100 {
                self.mode.wrappedValue.dismiss()
            }
        }))
    }
    
    
    // MARK: Search Bar
    var searchBar: some View {
        HStack {
            
            TextField("\(Image(systemName: "magnifyingglass")) 검색", text: $searchText)
                .disableAutocorrection(true)
                .foregroundColor(searchText.isEmpty ? Color(.systemGray) : .black)
                .onChange(of: searchText) { _ in
                    didChangedSearchText()
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
                Text("선수 이름, 응원가를 검색해주세요")
                    .foregroundColor(Color(.systemGray))
                    .padding(30)

            } else {
                
                List {
                    ForEach(autoComplete.indices, id: \.self) { index in
                        NavigationLink(destination: SongInformationView()) {
                            HStack {
                                
                                Image(systemName: "magnifyingglass")
                                Text(autoComplete[index])
                            }
                        }
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
                .foregroundColor(.blue)
            
            HStack(spacing: 17) {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.black)
                    .onTapGesture {
                        self.mode.wrappedValue.dismiss()
                    }
                
                searchBar
            }
            .padding(.horizontal, 20)
            .padding(.top, 50)
        }
        .ignoresSafeArea()
    }
    
    private func didChangedSearchText() {
        
        autoComplete = []
        
        for data in testData {
            if data.contains(searchText.lowercased()) {
                autoComplete.append(data)
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
