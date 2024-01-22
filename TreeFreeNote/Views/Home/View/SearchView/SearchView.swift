//
//  SearchView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 06/06/23.
//

import SwiftUI

struct SearchView: View {
    @Binding var searchText: String
    var placeHolderText: String
    var searchAction: () -> Void
    
    var body: some View {
        HStack(spacing: 2) {
            ///Search View 
            Image(systemName: "magnifyingglass")
            TextField(placeHolderText, text: $searchText)
                .padding(.vertical)
                .padding(.horizontal, 5)
                .frame(height: 40)
                
        }
        .padding(.horizontal, 10)
        .background(Color.clear)
        .clipShape(Capsule())
        .overlay(Capsule()
            .stroke(.gray, lineWidth: 1))
    }
}

struct SearchView_Previews: PreviewProvider {
    @State static var text: String = "Text"
    static var previews: some View {
        SearchView(searchText: $text, placeHolderText: "Search") {
            print(text)
        }
    }
}
