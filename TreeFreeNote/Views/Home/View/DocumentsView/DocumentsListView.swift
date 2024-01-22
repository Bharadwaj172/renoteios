//
//  DocumentsListView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 05/06/23.
//

import SwiftUI

struct DocumentsListView: View {
    @Binding var isTabViewShown: Bool
    @Binding var isShowingBottomSheet: Bool
    @Binding var isDocumentDialogShown: Bool
    @Binding var bottomSheetContentType: BottomSheetType
    @Binding var selectedTab: String

    @ObservedObject var documentViewModel = DocumentsViewModel()
    @ObservedObject var documentsObserver = DocumentsObserver.shared
        
    var selectedFolderId: String?
    
    var body: some View {
        
        ScrollView {
            if (!documentViewModel.documentsList.isEmpty) {
                LazyVStack(alignment: .leading, spacing: 10, pinnedViews: .sectionHeaders) {
                    ForEach(documentViewModel.documentsList.reversed()){ document in
                        NavigationLink {
                            ScannedImagePreviewView(imageNames: self.getDocumentDetails(documentId: document.id) , isFromScanner: false, isShowingBottomSheet: $isShowingBottomSheet, bottomSheetContentType: $bottomSheetContentType, isNavigated: .constant(false), selectedTab: $selectedTab, isTabViewShown: $isTabViewShown, documentsViewModel: documentViewModel, ocrText: "")
                            
                        } label: {
                            DocumentListCell(document: document, isShowingBottomSheet: $isShowingBottomSheet, bottomSheetContentType: $bottomSheetContentType, isDocumentDialogShown: $isDocumentDialogShown)
                                .frame(height: 100)
                        }
                        Divider()
                    }
                }
            } else {
                VStack {
                    Spacer()
                    HStack(alignment: .center) {
                        Spacer()
                        Text("No Data Available")
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .onChange(of: documentsObserver.isDocumentsSaved, perform: {newValue in
            getDocumentsData()
            DocumentsObserver.shared.isDocumentsSaved = false
        })
        .onAppear {
            getDocumentsData()
        }
        .onDisappear {
            print("Disappear")
        }
    }
    
    func getDocumentsData() {
        if let selectedFolderId = selectedFolderId {
            documentViewModel.getDocumentsList(with: selectedFolderId)
        } else {
            documentViewModel.getDocumentsFromDB()
        }
    }
    
    func navigateToDetailedView(document : String) -> UIImage? {
        if let image = DocumentHandler().loadImageFromDocumentDirectory(fileName: document) {
            return image
        }
        return nil
    }
    
    func getDocumentDetails(documentId: String) -> [UIImage] {
        let documentDetails = querys().getDocumentsHomePageInfo(documentId: documentId)
        var imagesArray = [UIImage]()
        for pageInfo in documentDetails {
            if let imagePath = pageInfo["file_path"] as? String {
                imagesArray.append((self.navigateToDetailedView(document: imagePath) ?? UIImage(named: "logo"))!)
            }
        }
        
        return imagesArray
    }
    
}

//struct DocumentsListView_Previews: PreviewProvider {
//    static var previews: some View {
//        DocumentsListView(documentViewModel: <#DocumentsViewModel#>)
//    }
//}


class DocumentsObserver: ObservableObject {
    static var shared = DocumentsObserver()
    @Published var isDocumentsSaved: Bool = false
}
