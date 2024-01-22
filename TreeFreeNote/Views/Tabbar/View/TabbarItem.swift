//
//  TabbarItemView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 31/05/23.
//

import SwiftUI

struct TabbarItem: View {
    
    var animation: Namespace.ID
    var title: String
    var image: String
    var tag: Int
    @Binding var selectedTab: String
    
    var body: some View {
        Button(action: {
            withAnimation {
                selectedTab = title
                AppSharedInstance.shared.selectedTab = title
            }
        }) {
            VStack(spacing: 5) {
                Image(image)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio( contentMode: .fit)
                    .frame(width: 28, height: 28)
                    .foregroundColor((selectedTab == title) ? .red : .black)
                Text(title)
                    .font(.system(size: 10))
                    .foregroundColor((selectedTab == title) ? .red : .black)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

//struct TabbarItemView_Previews: PreviewProvider {
//    @Namespace var animation
//
//    static var previews: some View {
//        TabbarItem(animation: animation, title: "Home", image: "Home", selectedTab: .constant("Home"))
//    }
//}
