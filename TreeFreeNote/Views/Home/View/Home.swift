//
//  Home.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 29/05/23.
//

import SwiftUI
import Combine

struct Home: View {
    //Selected Category..
    @Binding var selectedCategory: Category?
    @Binding var bottomSheetContentType: BottomSheetType
    @Binding var isShowingBottomSheet: Bool
    @Binding var isAlertShown: Bool
    @Binding var isTabViewShown: Bool

    @Binding var isDocumentDialogShown: Bool

//    @ObservedObject var categoriesViewModel : CategoriesViewModel

    @ObservedObject var documentsViewModel : DocumentsViewModel
    
    @State var folderViewModel = FoldersViewModel()
    
    @ObservedObject var testObservable = TestObservers.shared

    let onFolderUpdate = NotificationCenter.default
        .publisher(for: .onFolderCreation)

    var body: some View {
        NavigationView {
            VStack{
                ///NavigationHeaderView
                NavigationHeaderView()
                Spacer(minLength: 1)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10, content: {
     /*
                        ///ToolsView..
                        ToolsView()
                        Spacer(minLength: 2)
      */
                        ///Search View
                        HomeScreenSearchContainerView(isShowingBottomSheet: $isShowingBottomSheet, bottomSheetContentType: $bottomSheetContentType, isAlertShown: $isAlertShown, isDocumentEditShown: $isDocumentDialogShown)
                            .padding(10)
                        
                        ///Categories View
                        CategoriesView()
                            .padding(10)
 
                        //Folder Horizontal View
                        if !folderViewModel.foldersArray.isEmpty {
                            FoldersHorizontalListView(foldersArray: folderViewModel.foldersArray, isShowingBottomSheet: $isShowingBottomSheet, isDocumentDialogShown: $isDocumentDialogShown, isTabViewShown: $isTabViewShown, bottomSheetContentType: $bottomSheetContentType, selectedTab: .constant("Home"), documentsViewModel: documentsViewModel)
                                .frame(height: 120)
                        }
                        
                        Divider()
                        ///Documents ListView
                        DocumentsListView(isTabViewShown: $isTabViewShown, isShowingBottomSheet: $isShowingBottomSheet, isDocumentDialogShown: $isDocumentDialogShown, bottomSheetContentType: $bottomSheetContentType, selectedTab: .constant("Home") , documentViewModel: documentsViewModel)
                    })
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
            .navigationBarHidden(true)
            .navigationBarTitle(Text("Home"))
            //            .edgesIgnoringSafeArea([.top, .bottom])
            
            //Light BG Color..
            .background(Color.white.ignoresSafeArea())
        }
//        .onReceive(onFolderUpdate) { _ in
//            folderViewModel.refreshFoldersInfo()
//        }
        .onChange(of: testObservable.isDocumentSaved, perform: { newValue in
            folderViewModel.getFoldersInfo()
            TestObservers.shared.isDocumentSaved = false
        })
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                folderViewModel.getFoldersInfo()
            }
        }
    }
    
//    func refreshFoldersInfo() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            self.foldersArray = querys().getHomePageInfo() // Update the @State property with fetched data
//        }
//    }
}

//struct Home_Previews: PreviewProvider {
////    static var previews: some View {
////        Home(selectedCategory: .constant(categories.first!), bottomSheetContentType: .constant(.newTag), isShowingBottomSheet: .constant(false), categoriesViewModel: .constant(CategoriesViewModel()))
////    }
//}


class TestObservers: ObservableObject {

    static var shared = TestObservers()
    
    @Published var isDocumentSaved: Bool = false
    
    @Published var isScannedDocUpdated: Bool = false
    
}
