//
//  ColudSyncModel.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 23/09/23.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher
import GLKit

class ColudSyncModel : NSObject {
 
    func uploadScannedImagesToGoogleDrive(user: GIDGoogleUser, imagePaths: [String], folderName: String) {
        let googleDriveService = GTLRDriveService()
        googleDriveService.authorizer = user.fetcherAuthorizer
        checkGoogleFolderAvailability(folder_name: folderName, googleDriveService: googleDriveService, user: user, completion: { parent_folder_id in
            for path in imagePaths {
                let filePath : String =  path
                let file = GTLRDrive_File()
                file.name = URL(string: filePath)?.lastPathComponent
                file.parents = [parent_folder_id]
                if let fileUrl = URL(string: "file://" + filePath) {
                    // Optionally, GTLRUploadParameters can also be created with a Data object.
                    let uploadParameters = GTLRUploadParameters(fileURL: fileUrl, mimeType: "image/jpeg")
                    let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParameters)
                    googleDriveService.uploadProgressBlock = { _, totalBytesUploaded, totalBytesExpectedToUpload in
                        // This block is called multiple times during upload and can
                        // be used to update a progress indicator visible to the user.
                        //TODO: Show loading indicator at upload time
                    }
                    googleDriveService.executeQuery(query) { (_, result, error) in
                        guard error == nil else {
                            fatalError(error!.localizedDescription)
                        }
                        // Successful upload if no error is returned.
                        print(result as Any)
                    }
                }
                
            }
        })
        
    }
 
    func checkGoogleFolderAvailability(folder_name: String, googleDriveService : GTLRDriveService, user: GIDGoogleUser, completion: @escaping (String) -> Void) {
        var parent_folder_id = ""
        getFolderID(name: folder_name as String, service: googleDriveService, user: user, completion: {(status) in
            if status != nil{
                print(String(status!),"folder ID")
                parent_folder_id = status!
                completion(parent_folder_id)
//                self.uploadFileInfolder(folderName: name as String, filevalue: filepath, user: user)
            }else{
                self.createFolder(name: folder_name as String, service: googleDriveService, completion: {(status) in
                    print(status)
                    print(String(status),"folder created ID")
                    parent_folder_id = status
                    completion(parent_folder_id)
//                    self.uploadFileInfolder(folderName: name as String, filevalue: filepath, user: user)
                    
                })
            }
        })
//        return parent_folder_id
    }
    func createFolder(
            name: String,
            service: GTLRDriveService,
            completion: @escaping (String) -> Void) {
    
            let folder = GTLRDrive_File()
            folder.mimeType = "application/vnd.google-apps.folder"
            folder.name = name
//                if parent_folderID.count > 0{
//                folder.parents = [parent_folderID]
//            }
            // Google Drive folders are files with a special MIME-type.
            let query = GTLRDriveQuery_FilesCreate.query(withObject: folder, uploadParameters: nil)
                service.executeQuery(query) { (_, file, error) in
                if error != nil {
                    print(error as Any)
                }
                //            let folder : GTLRDrive_File  = file as! GTLRDrive_File
                    if file != nil{
                    let folder = file as! GTLRDrive_File
                    completion(folder.identifier!)
                }
            }
        }
    
 
    func getFolderID(
        name: String,
        service: GTLRDriveService,
        user: GIDGoogleUser,
        completion: @escaping (String?) -> Void) {
            let query = GTLRDriveQuery_FilesList.query()
            // Comma-separated list of areas the search applies to. E.g., appDataFolder, photos, drive.
            query.spaces = "drive"
            // Comma-separated list of access levels to search in. Some possible values are "user,allTeamDrives" or "user"
                        query.corpora = "user"
            let withName = "name = '\(name)'" // Case insensitive!
            let foldersOnly = "mimeType = 'application/vnd.google-apps.folder'"
            let ownedByUser = "'\(user.profile!.email)' in owners"
            query.q = "\(withName) and \(foldersOnly) and \(ownedByUser)"
            service.executeQuery(query) { (_, result, error) in
                if error != nil {
                    print(error as Any)
                    completion(nil)
                    return
                }
                let folderList : GTLRDrive_FileList  = result as! GTLRDrive_FileList
                if folderList.files?.first?.identifier == nil{
                    completion(nil)
                    return
                }
                print(folderList,"folderList")
                completion(folderList.files?.first?.identifier)
            }
        }
}
