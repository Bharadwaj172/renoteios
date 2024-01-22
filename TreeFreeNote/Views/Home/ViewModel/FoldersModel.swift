//
//  FoldersModel.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 25/09/23.
//

import Foundation

struct FolderModel: Identifiable, Equatable, Hashable {
    public var id: String = ""
    public var createdDate: String = ""
    public var folderName: String = ""
    public var parentFolder: String = ""
    public var storageType: String = ""
    public var cloudStoreId: String = ""
    public var pinStatus: String = ""
    public var documentCount: String = ""
    public var syncStatusCount: String = ""
    
    static func == (lhs: FolderModel, rhs: FolderModel) -> Bool {
        return lhs.folderName == rhs.folderName
    }
}
