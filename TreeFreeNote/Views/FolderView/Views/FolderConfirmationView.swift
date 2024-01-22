//
//  FolderConfirmationView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 01/07/23.
//

import SwiftUI

enum FolderAlertType {
    case confirmationAlert
    case eraseAlert
    
}

struct FolderConfirmationView: View {
    
    var alertType: FolderAlertType
    
    private var alertTitle: String {
        switch alertType {
        case .confirmationAlert:
            return "Folder Destion Update"
        case .eraseAlert:
            return "Are you sure!"
        }
    }
    
    private var image: String {
        switch alertType {
        case .confirmationAlert:
            return "xmark.circle"
        case .eraseAlert:
            return "eye.slash.fill"
        }
    }
    
    private var description: String {
        switch alertType {
        case .confirmationAlert:
            return "Folder Destion Update Folder Destion Update Folder Destion Update Folder Destion Update Folder Destion Update \n\n Folder Destion Update Folder Destion Update"
        case .eraseAlert:
            return "Do You want to erase the file"
        }
    }
    
    private var confirmButtonTitle: String {
        switch alertType {
        case .confirmationAlert:
            return "Confirm"
        case .eraseAlert:
            return "Erase"
        }
    }
    
    private var confirmButtonGradient: LinearGradient {
        switch alertType {
        case .confirmationAlert:
            return LinearGradient(gradient: Gradient(colors: [Color(UIColor(red: 3/255.0, green: 151/255.0, blue: 41/255.0, alpha: 1)), Color(UIColor(red: 78/255.0, green: 234/255.0, blue: 118/255.0, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
        case .eraseAlert:
            return LinearGradient(gradient: Gradient(colors: [Color(UIColor(red: 217/255.0, green: 45/255.0, blue: 32/255.0, alpha: 1)), Color(UIColor(red: 237/255.0, green: 109/255.0, blue: 99/255.0, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48, height: 48)
                    .foregroundColor(Color.gray)
                .padding(.horizontal, 10)
                Spacer()
            }
            
            VStack(spacing: 10) {
                Text(alertTitle)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(Color.black)
                    .padding(.horizontal, 16)
                Text(description)
                    .font(.callout)
                    .fontWeight(.light)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 16)
            }
            .padding(.bottom, 10)
            
            HStack {
                Button (action: { print("create Folder pressed!!") }) {
                    Text("Cancel")
                        .fontWeight(.medium)
                        .padding(10)
                        .foregroundColor(.black)
                        .padding (.horizontal, 50)
                }
                .overlay(Capsule()
                    .stroke(Color.gray, lineWidth: 1))
                
                Button (action: { print("create Folder pressed!!") }) {
                    Text(confirmButtonTitle)
                        .fontWeight(.medium)
                        .padding(10)
                        .foregroundColor(.white)
                        .padding (.horizontal, 50)
                }
                .background(confirmButtonGradient)
                .cornerRadius(36, corners: .allCorners)
            }
        }
        .padding(.vertical,8)
        .padding(.bottom, 34)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct FolderConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        FolderConfirmationView(alertType: .confirmationAlert)
    }
}
