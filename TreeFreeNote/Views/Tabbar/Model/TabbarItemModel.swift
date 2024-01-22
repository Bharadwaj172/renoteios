//
//  TabbarItemModel.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 31/05/23.
//

import Foundation

struct TabbarItemModel: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var image: String
    var tag: Int
}

var tabbarItems = [
    TabbarItemModel(title: "Home", image: "Home", tag: 1),
   TabbarItemModel(title: "QR Scan", image: "qrScan", tag: 2),
   TabbarItemModel(title: "OCR Scan", image: "OCR", tag: 3),
   TabbarItemModel(title: "Import", image: "Import", tag: 4),
]

