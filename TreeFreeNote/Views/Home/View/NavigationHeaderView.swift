//
//  NavigationHeaderView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 29/05/23.
//

import SwiftUI

struct NavigationHeaderView: View {
    var body: some View {
        HStack {
            Button(action: {}) {
                Image("logo")
                    .font(.title2)
                    .padding(10)
                    .background(Color.clear)
                    .foregroundColor(Color.black)
                    .cornerRadius(8)
            }
            Spacer()
            /*
            CustomLogoButton(imageName: "syncLogoIcon") {
                print("Sync Icon Clicked")
            }
           
            CustomLogoButton(imageName: "TranslateIcon") {
                print("translate Icon Clicked")
            }
            
            CustomLogoButton(imageName: "profile") {
                print("profile Icon Clicked")
            }
             */
        }
    }
}

struct NavigationHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationHeaderView()
    }
}
