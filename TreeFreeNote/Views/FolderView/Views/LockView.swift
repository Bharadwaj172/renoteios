//
//  LockView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 01/07/23.
//

import SwiftUI

struct LockView: View {
    
    @Binding var isFolderLockEnabled: Bool
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text("Lock")
                    .font(.title3)
                    .fontWeight(.regular)
                    .foregroundColor(Color.black)
                    .frame(width: 100, alignment: .leading)
                    .padding(.trailing, 16)
                HStack {
                    RadioButton(checked: .constant(isFolderLockEnabled), radioTitle: "Yes") {
                        self.isFolderLockEnabled.toggle()
                    } onTapToInactive: {
                        self.isFolderLockEnabled.toggle()
                    }
                    .padding(.trailing, 16)
                    RadioButton(checked: .constant(!isFolderLockEnabled), radioTitle: "No") {
                        self.isFolderLockEnabled.toggle()
                    } onTapToInactive: {
                        self.isFolderLockEnabled.toggle()
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .frame(height: 35)

        }
        .padding(.horizontal, 27)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct LockView_Previews: PreviewProvider {
    static var previews: some View {
        LockView(isFolderLockEnabled: .constant(true))
    }
}
