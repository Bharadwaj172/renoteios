//
//  ColorExtension.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 05/06/23.
//

import SwiftUI

extension Color {
    static let priaryTextColor = Color(hex: "#303030").opacity(0.98)
    static let secondaryTextColor = Color(hex: "#303030").opacity(0.64)// FolderPaths, mail info
    static let descriptionTextColor = Color(hex: "#303030").opacity(0.48) // Count label, date details
    static let categoriesTextColor = Color(hex: "#303030").opacity(0.80)
    static let iconForegroundColor = Color(hex: "#303030")
    static let blackColor = Color(hex: "#000000")
}

// Color HEX conversion logic
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
