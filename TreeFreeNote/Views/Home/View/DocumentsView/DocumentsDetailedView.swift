//
//  DocumentsDetailedView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 01/07/23.
//

import SwiftUI

struct DocumentsDetailedView: View {
    var documentInfo: Document
    
    var body: some View {
        Text(documentInfo.title)
    }
}

//struct DocumentsDetailedView_Previews: PreviewProvider {
//    static var previews: some View {
//        DocumentsDetailedView(documentInfo: DocumentModel(name: "Document", imageName: "ca", dateCreated: "21635 76", cloudAccount: "", documentFolderName: "", pagesCount: 3))
//    }
//}
