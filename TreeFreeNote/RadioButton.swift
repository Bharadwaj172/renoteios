//
//  RadioButton.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 01/07/23.
//

import SwiftUI

struct RadioButton: View {
//    let isSelected: Bool
    @Binding var checked: Bool
    let radioTitle: String
    var onTapToActive: ()-> Void//action when taped to activate
    let onTapToInactive: ()-> Void //action when taped to inactivate
    
    var body: some View {
        Group{
            if checked {
                HStack(alignment: .center, spacing: 16) {
                    ZStack{
                        Circle()
                            .stroke(Color.green, lineWidth: 1)
                            .frame(width: 20, height: 20)
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                    }.onTapGesture {
                        self.onTapToInactive()
                        self.checked = true
                    }
                    Text(radioTitle)
                        .font(.headline)
                }
            } else {
                HStack(alignment: .center, spacing: 16){
                    Circle()
                        .fill(Color.white)
                        .frame(width: 20, height: 20)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        .onTapGesture {self.onTapToActive()
                            self.checked = false
                        }
                    
                    Text(radioTitle)
                        .font(.headline)
                }
            }
        }
    }
}

struct RadioButton_Previews: PreviewProvider {
    static var previews: some View {
        RadioButton(checked: .constant(true), radioTitle: "Yes") {
            print("Active")
        } onTapToInactive: {
            print("InActive")
        }
    }
}
