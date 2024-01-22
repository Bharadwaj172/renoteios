//
//  CloudIntegrationView.swift
//  TreeFreeNote
//
//  Created by Vinod Kodavath on 12/09/23.
//

import SwiftUI
import GoogleSignIn

struct CloudIntegrationView: View {
    @EnvironmentObject var googleAuth : GoogleAuthModel
    var body: some View {
        Button(action: {
            googleAuth.signIn()
        }, label: {
            Text("google sign")
        })
    }
}

struct CloudIntegrationView_Previews: PreviewProvider {
    static var previews: some View {
        CloudIntegrationView()
    }
}
