//
//  DBQueries.swift
//  TreeFreeNote
//
//  Created by Vinod Kodavath on 23/07/23.
//

import Foundation

enum DBTableName: String {
    case folders
    case documents
    case pages
    case security
    case tags
}

class querys {
//    init(){
//    }
    let dbManager = DBManager.shared
    //creating Tables
    let folderTableString = "CREATE TABLE IF NOT EXISTS folders(Id INTEGER PRIMARY KEY,created_date TEXT, folder_name TEXT, parent_folder TEXT, storage_type TEXT, cloud_storage_id TEXT, pin_status TEXT NOT NULL DEFAULT '0');"
    
    let documentTableString = "CREATE TABLE IF NOT EXISTS documents(Id INTEGER PRIMARY KEY,document_name TEXT,created_date TEXT, document_type TEXT, linked_tag_id TEXT, security TEXT, folder_id INTEGER, sync INTEGER NOT NULL DEFAULT '0', pin_status INTEGER NOT NULL DEFAULT '0');"
    
    let pagesTableString = "CREATE TABLE IF NOT EXISTS pages(Id INTEGER PRIMARY KEY, document_id INTEGER, page_number INTEGER, file_path TEXT);"
    
    let securityTableString = "CREATE TABLE IF NOT EXISTS security(Id INTEGER PRIMARY KEY, salt TEXT,password TEXT, security_type TEXT);"
    
    let tagTableString = "CREATE TABLE IF NOT EXISTS tags(Id INTEGER PRIMARY KEY, tag_name TEXT);"
    
    
    let home_page_folder_query = "select f.*,count(d.id) as documentCount , SUM(CASE WHEN d.sync=1 THEN 1 ELSE 0 END) as syncStatusCount from folders as f left join documents as d on f.id=d.folder_id group by f.id"

    let documents_home_page_query = "select d.*,fp.file_path,f.folder_name as parent_folder,sub.folder_name as sub_folder_name  from documents as d  left join folders as sub on sub.id=d.folder_id left join (select s.id,ls.folder_name from folders as s left join folders as ls on ls.id=s.parent_folder group by ls.id) as f on f.id=d.folder_id inner join  pages as fp on (fp.document_id=d.id and fp.page_number=1) group by d.id"
    
    let documentsDetailsQuery = "select * from pages where document_id ="
    
    let folderDetailsQuery = "select d.*,fp.file_path, f.storage_type from documents as d inner join folders as f on f.id = d.folder_id inner join  pages as fp on (fp.document_id=d.id and fp.page_number=1) where d.folder_id = '%@' group by d.id"
    
    func create_tables(){
        dbManager.createTable(sql_query: folderTableString)
        dbManager.createTable(sql_query: documentTableString)
        dbManager.createTable(sql_query: pagesTableString)
        dbManager.createTable(sql_query: securityTableString)
        dbManager.createTable(sql_query: tagTableString)
        self.checkDefaultTagsInfo()
    }
    
    func insertFolder(folder_name: String, parent_folder: String, cloud_storage_id: String, storage_type: String){
        let dateString = Utility().current_date()
        print(dateString)
        var query : String = ""
        let sqlQuery : String = String(format: "(\"%@\",\"%@\", \"%@\", \"%@\", \"%@\")",dateString, folder_name, parent_folder, cloud_storage_id, storage_type)
        query.append(sqlQuery)
        let insertFolderString = "INSERT INTO folders(created_date, folder_name, parent_folder, cloud_storage_id, storage_type) VALUES \(query);"
        dbManager.insert(insert_query: insertFolderString)
        
    }
    
    // Insertng data into tables
    func insertDocuments(title: String, documentType: String, linkedTagId: String, security: String, storage_type: String, folderId: String){
        let dateString = Utility().current_date()
        var query : String = ""
        let sqlQuery : String = String(format: "(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")", title, dateString, documentType, linkedTagId, security, folderId)
        query.append(sqlQuery)
        let insertdocumentString = "INSERT INTO documents(document_name, created_date, document_type, linked_tag_id, security, folder_id) VALUES \(query);"
        dbManager.insert(insert_query: insertdocumentString)
        
    }
    
    func insertPages(documentId: String, filesPathArray: [String]){
//        var query : String = ""
        var index = 1
        for filePath in filesPathArray{
            let sqlQuery : String = String(format: "(\"%@\",\"%@\",\"%@\")", String(documentId), String(index), filePath)
            index += 1
            let insertPagesString = "INSERT INTO pages(document_id, page_number, file_path) VALUES \(sqlQuery);"
            dbManager.insert(insert_query: insertPagesString)
        }
    }

    func insertSecurity(salt: String, password: String, security_type: String){
        var query : String = ""
        let sqlQuery : String = String(format: "(\"%@\",\"%@\", \"%@\")",salt, password, security_type)
        query.append(sqlQuery)
        let insertFolderString = "INSERT INTO security(salt, password, security_type) VALUES \(query);"
        dbManager.insert(insert_query: insertFolderString)
        
    }
    
    func insertTags(tag_name: String){
        var query : String = ""
        let sqlQuery : String = String(format: "(\"%@\")",tag_name)
        query.append(sqlQuery)
        let insertFolderString = "INSERT INTO tags(tag_name) VALUES \(query);"
        dbManager.insert(insert_query: insertFolderString)
    }
    
    func get_max_id_table(table_name: String) -> String{
        return dbManager.getMaxRowId(tableName: table_name)
    }
    
    func get_value_of_tabel(tableName: String) -> Array<Dictionary<String, Any>> {
       let values = dbManager.getValues(tableName: tableName) //DBTableName.pages.rawValue
        print(values)
        return values
    }
    
    func value_exits(folder_name: String) -> Bool{
        let folder_Query : String = String(format: "\"%@\"",folder_name)
        let status = dbManager.getValuesExitsOrNot(folder_name: folder_Query)
        return status
    }
    
    func get_folder_id(folder_name: String) -> String{
        let folder_Query : String = String(format: "\"%@\"",folder_name)
        let row_id = dbManager.get_row_id_of_exting_folder(tableName: DBTableName.folders.rawValue, folder_name:folder_Query)
        return row_id
    }
    
    func getHomePageInfo() -> Array<Dictionary<String, Any>> {
        return dbManager.getQueryDetails(query: home_page_folder_query)
    }
    
    func getDocumentsHomePageInfo() -> Array<Dictionary<String, Any>> {
        return dbManager.getQueryDetails(query: documents_home_page_query)
    }

    func getDocumentsHomePageInfo(documentId: String) -> Array<Dictionary<String, Any>> {
        return dbManager.getQueryDetails(query: documentsDetailsQuery + documentId)
    }

    func getDocumentsListWith(folderId: String) -> Array<Dictionary<String, Any>> {
        let query = "select d.*,fp.file_path, f.storage_type from documents as d inner join folders as f on f.id = d.folder_id inner join  pages as fp on (fp.document_id=d.id and fp.page_number=1) where d.folder_id = '\(folderId)' group by d.id"
        return dbManager.getQueryDetails(query: query)
    }

    
    func checkDefaultTagsInfo() {
        let values = self.get_value_of_tabel(tableName: DBTableName.tags.rawValue)
        if values.isEmpty {
            self.insertDefaultDefaultTagsInfo()
        }
    }
    
    func insertDefaultDefaultTagsInfo() {
        self.insertTags(tag_name: "All")
        self.insertTags(tag_name: "Starred")
        self.insertTags(tag_name: "MostViewed")
    }
    
}



//CREATE TABLE Page (
//    id INTEGER PRIMARY KEY,
//    documentId INTEGER,
//    pageNumber INTEGER,
//    imagePath TEXT,
//    -- Other page metadata columns
//    FOREIGN KEY (documentId) REFERENCES Document(id)
//);
