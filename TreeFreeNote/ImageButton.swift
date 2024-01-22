//
//  ImageButton.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 29/07/23.
//

import SwiftUI

struct ImageButton<Label: View>: View {
    let action: () -> Void
    let imageName: String
    let label: () -> Label
    
    init(action: @escaping () -> Void, imageName: String, @ViewBuilder label: @escaping () -> Label) {
        self.action = action
        self.imageName = imageName
        self.label = label
    }
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(imageName)
                    .font(.title)
                label()
            }
        }
    }
}
