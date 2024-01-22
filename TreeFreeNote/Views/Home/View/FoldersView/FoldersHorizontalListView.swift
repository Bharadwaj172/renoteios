//
//  FoldersHorizontalListView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 06/06/23.
//

import SwiftUI

struct FoldersHorizontalListView: View {
    var foldersArray: [FolderModel] //= [] // State to hold fetched data
    @Binding var isShowingBottomSheet: Bool
    @Binding var isDocumentDialogShown: Bool
    @Binding var isTabViewShown: Bool
    @Binding var bottomSheetContentType: BottomSheetType
    @Binding var selectedTab: String

    @ObservedObject var documentsViewModel : DocumentsViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 10) {
                ForEach(0..<foldersArray.count, id: \.self) { index in
                    NavigationLink {
                        DocumentsListView(isTabViewShown: $isTabViewShown, isShowingBottomSheet: $isShowingBottomSheet, isDocumentDialogShown: $isDocumentDialogShown, bottomSheetContentType: $bottomSheetContentType, selectedTab: $selectedTab , documentViewModel: documentsViewModel, selectedFolderId: foldersArray[index].id)

                    } label: {
                        CustomFoldersListCell(folderInfo: foldersArray[index])
                            .frame(width: 200, height: 120)
                    }
                }
            }
        }
        .frame(height: 120)
    }
}

//struct FoldersHorizontalListView_Previews: PreviewProvider {
//    static var previews: some View {
//        FoldersHorizontalListView()
//    }
//}
