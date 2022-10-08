//
//  SongSearchView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

struct SongSearchView: View {
    
    @State var searchText = ""
    @State var autoComplete = [String]()
    @State var testData = ["안녕하세요", "두산", "이지원", "이쏘이", "정인이", "티나", "안나", "엘리", "예니", "dkssud"]
    
    
    var body: some View {
        
        VStack {
            
            searchBar
                .padding(.horizontal, 20)
            
            resultView
            
            Spacer()
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    
    // MARK: Search Bar
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            
            TextField("검색", text: $searchText)
                .disableAutocorrection(true)
                .foregroundColor(Color(.systemGray))
                .onChange(of: searchText) { _ in
                    didChangedSearchText()
                }
            
            if searchText != "" {
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
        .frame(height: 30)
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(30)
        .padding(.vertical, 10)
    }
    
    
    // MARK: Result View
    var resultView: some View {
        
        VStack {
            if searchText.isEmpty {

                Text("선수 이름, 응원가를 검색해주세요")
                    .foregroundColor(Color(.systemGray))

            } else {
                
                List {
                    ForEach(autoComplete.indices, id: \.self) { index in
                        NavigationLink(destination: SongInformationView()) {
                            VStack {
                                Text(autoComplete[index])
                            }
                        }
                    }
                }
                .listStyle(.plain)
                
            }
        }
        
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
