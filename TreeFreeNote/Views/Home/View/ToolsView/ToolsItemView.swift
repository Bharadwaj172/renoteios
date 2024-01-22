//
//  ToolsItemView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 29/05/23.
//

import SwiftUI

struct ToolsItemView: View {
    var title: String
    var image: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            
            Button {
                print(title)
            } label: {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .font(.title2)
                    .padding(4)
                    .frame(width: 45, height: 45)
            }

            Text(title)
                .font(.subheadline)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.primary)
                .padding(.horizontal, 5)
            
        }
//        .frame(width: 65, height: 65)

    }
}

struct ToolsItemView_Previews: PreviewProvider {
    static var previews: some View {
        ToolsItemView(title: "Merge PDF", image: "splitPdf")
    }
}
