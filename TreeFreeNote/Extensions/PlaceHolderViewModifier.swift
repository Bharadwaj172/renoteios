//
//  PlaceHolderViewModifier.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 11/09/23.
//

import SwiftUI

public struct PlaceholderStyle: ViewModifier {
    var showPlaceHolder: Bool
    var placeholder: String

    public func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if showPlaceHolder {
                Text(placeholder)
                .padding(.horizontal, 15)
                .foregroundColor(Color.gray)
            }
            content
            .foregroundColor(Color.black)
            .padding(5.0)
        }
    }
}
