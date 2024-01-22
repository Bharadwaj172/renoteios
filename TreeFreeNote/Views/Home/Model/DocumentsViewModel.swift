//
//  DocumentsViewModel.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 23/08/23.
//

import Foundation

public class DocumentsViewModel : ObservableObject {
    @Published var documentsList: [DocumentModel] = []

    init() {
        self.getDocumentsFromDB()
    }

    func getDocumentsFromDB() {
        let documentsArray = querys().getDocumentsHomePageInfo()
        self.documentsList.removeAll()
        self.parseDocumentsDetails(documentsArray: documentsArray)
    }
    
    
    func getDocumentsList(with folderId: String) {
        let documentsArray = querys().getDocumentsListWith(folderId: folderId)
        self.documentsList.removeAll()
        self.parseDocumentsDetails(documentsArray: documentsArray)

    }
    
    func parseDocumentsDetails(documentsArray: Array<Dictionary<String, Any>>) {
        
        for folderDetails in documentsArray {
            var documentModel = DocumentModel()
            if let id = folderDetails["Id"] as? String {
                documentModel.id = id
            }
            if let created_date = folderDetails["created_date"] as? String {
                documentModel.dateCreated = created_date
            }
            if let folder_name = folderDetails["document_name"] as? String {
                documentModel.name = folder_name
            }
            if let document_type = folderDetails["document_type"] as? String {
                documentModel.documentType = document_type
            }
            if let linked_tag_id = folderDetails["linked_tag_id"] as? String {
                documentModel.linkedTagId = linked_tag_id
            }
            if let folder_id = folderDetails["folder_id"] as? String {
                documentModel.folderId = folder_id
            }
            if let sync = folderDetails["sync"] as? String {
                documentModel.syncStatus = sync
            }
            if let pin_status = folderDetails["pin_status"] as? String {
                documentModel.pinStatus = pin_status
            }
            if let file_path = folderDetails["file_path"] as? String {
                documentModel.imageName = file_path
            }
            if let sub_folder_name = folderDetails["sub_folder_name"] as? String {
                documentModel.folderName = sub_folder_name
            }
            self.documentsList.append(documentModel)
            
        }
    }
}

