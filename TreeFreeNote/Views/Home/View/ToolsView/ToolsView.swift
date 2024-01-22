//
//  ToolsView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 29/05/23.
//

import SwiftUI

struct ToolsView: View {
    var body: some View {
        VStack(spacing: 2) {
            HStack{
                Text("Tools")
                    .foregroundColor(.black)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(4)
                Spacer()
            }
            HStack() {
                ToolsItemView(title: "Merge PDF", image: "mergePdf")
                ToolsItemView(title: "Split PDF", image: "splitPdf")
                ToolsItemView(title: "eSign PDF", image: "esignPdf")
                ToolsItemView(title: "All Tools", image: "AllTools")
            }
            .padding(.horizontal, 5)
        }
    }
}

struct ToolsView_Previews: PreviewProvider {
    static var previews: some View {
        ToolsView()
    }
}
