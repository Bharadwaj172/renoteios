//
//  CustomTabbar.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 31/05/23.
//

import SwiftUI

struct CustomTabbar: View {
    @Binding var selectedTab: String

    //Animation Namespace for sliding effect..
    @Namespace var animation
    
    let action: () -> Void

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.gray.opacity(0.05))
                .cornerRadius(35, corners: [.topLeft, .topRight])
            HStack(spacing: 0) {
                //Tab bar Button..
                TabbarItem(animation: animation, title: "Home", image: "Home", tag: 1, selectedTab: $selectedTab)
                TabbarItem(animation: animation, title: "QR Scan", image: "qrScan", tag: 2, selectedTab: $selectedTab)
                    .onTapGesture {
                        self.action()
                    }
                
                Button {
                    print("tap on camera")
                    self.action()
                    selectedTab = "Camera"
                } label: {
                    Image("camera")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio( contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .padding(20)
                        .background(Color.green)
                        .foregroundColor(Color.white)
                        .clipShape(Circle())
                    //shadows
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 5, y: -5)
                }
                .tag("Camera")
                .offset(y: -25)
                
                TabbarItem(animation: animation, title: "OCR Scan", image: "OCR", tag: 3, selectedTab: $selectedTab)
                TabbarItem(animation: animation, title: "Import", image: "Import", tag: 4, selectedTab: $selectedTab)
            }
            .padding(.top)
            //decrease extra padding space..
            .padding(.vertical, -10)
            .padding(.bottom, getSafeArea().bottom == 0 ? 15 : getSafeArea().bottom)
            .background(Color.clear)
            
        }
        .frame(height: 74)
    }
}

//struct CustomTabbar_Previews: PreviewProvider {
//    static var previews: some View {
////        CustomTabbar(selectedTab: .constant("Home"), action: <#() -> Void#>)
//    }
//}


//View Extension to get safeArea
extension View{
    func getSafeArea()-> UIEdgeInsets {
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}
