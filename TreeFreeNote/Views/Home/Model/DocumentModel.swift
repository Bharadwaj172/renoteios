//
//  DocumentModel.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 30/05/23.
//

import Foundation

struct DocumentModel: Identifiable, Equatable, Hashable {
    var id: String = ""
    var name: String = ""
    var imageName: String = ""
    var dateCreated: String = ""
    var documentType: String = ""
    var cloudAccount: String = ""
    var folderName: String = ""
    var folderId: String = ""
    var syncStatus: String = ""
    var pinStatus: String = ""
    var linkedTagId: String = ""
    var isSelected: Bool = false
}
