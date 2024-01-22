//
//  DocumentModel.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 11/07/23.
//

import Foundation

struct Document : Identifiable, Equatable, Codable, Hashable {
//    let id: String
    var id = UUID().uuidString
    var title: String
    let creationDate: String
    let fileFormat: String
//    var pages: [ScannedPage]
}
