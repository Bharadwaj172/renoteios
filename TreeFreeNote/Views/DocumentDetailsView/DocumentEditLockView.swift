//
//  DocumentEditLockView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 17/09/23.
//

import SwiftUI

struct DocumentEditLockView: View {
    var body: some View {
        VStack {
            VStack(alignment:.leading) {
                Text("Choose Pin")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Color.black)
                Spacer()
                PasscodeField("") { digits, action in
//                                if "1234" == digits.concat {
//                                    action(true)
//                                } else {
//                                    action(false)
//                                }
                }
                .fixedSize(horizontal: true, vertical: true)
            }
            .frame(height: 75)
            
            /*
            HStack {
                Text("Enable face Id")
                    .font(.title3)
                    .fontWeight(.regular)
                    .foregroundColor(Color.black)
                Spacer()
                
                Toggle("", isOn: $enableFaceId)
                    .toggleStyle(SwitchToggleStyle(tint: .green))
            }
            .padding(.top, 8)
             */
            
        }
        .padding(20)

    }
}

struct DocumentEditLockView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentEditLockView()
    }
}
