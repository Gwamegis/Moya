//
//  SongSearchView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

struct SongSearchView: View {
    
    @State var searchText = ""
    
    var body: some View {
        
        VStack {
            
            searchBar
                .padding(.horizontal, 20)
            
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
}


// MARK: Previews
struct SongSearchView_Previews: PreviewProvider {
    static var previews: some View {
        SongSearchView()
    }
}
