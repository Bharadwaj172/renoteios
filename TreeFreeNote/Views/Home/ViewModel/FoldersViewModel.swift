//
//  FoldersViewModel.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 24/09/23.
//

import SwiftUI
import Combine

class FoldersViewModel : ObservableObject {
    var foldersArray: [FolderModel] = []
    
    private var cancellable : AnyCancellable?
    
//    init() {
//        cancellable = $foldersArray.sink {_ in
//            self.refreshFoldersInfo()
//        }
//    }
    
    init() {
        self.getFoldersInfo()
    }
    
    func getFoldersInfo() {
        self.foldersArray.removeAll()
            
            let foldersInfo = querys().getHomePageInfo()
            print("refreshFoldersInfo-- %@", foldersInfo)
            
            for folderDetails in foldersInfo {
                var folderModel = FolderModel()
                if let id = folderDetails["Id"] as? String {
                    folderModel.id = id
                }
                if let created_date = folderDetails["created_date"] as? String {
                    folderModel.createdDate = created_date
                }
                if let folder_name = folderDetails["folder_name"] as? String {
                    folderModel.folderName = folder_name
                }
                if let parent_folder = folderDetails["parent_folder"] as? String {
                    folderModel.parentFolder = parent_folder
                }
                if let storage_type = folderDetails["storage_type"] as? String {
                    folderModel.storageType = storage_type
                }
                if let cloud_storage_id = folderDetails["cloud_storage_id"] as? String {
                    folderModel.cloudStoreId = cloud_storage_id
                }
                if let pin_status = folderDetails["pin_status"] as? String {
                    folderModel.pinStatus = pin_status
                }
                if let documentCount = folderDetails["documentCount"] as? String {
                    folderModel.documentCount = documentCount
                }
                if let syncStatusCount = folderDetails["syncStatusCount"] as? String {
                    folderModel.syncStatusCount = syncStatusCount
                }
                
                self.foldersArray.append(folderModel)
            }
        
    }
}
