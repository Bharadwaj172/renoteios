//
//  ViewExtension.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 11/09/23.
//

import SwiftUI

extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View{
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}
