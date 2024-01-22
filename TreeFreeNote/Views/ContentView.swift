//
//  ContentView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 30/05/23.
//

import SwiftUI
import Combine
import GoogleSignIn

extension View {
    func onReceive(
        _ name: Notification.Name,
        center: NotificationCenter = .default,
        object: AnyObject? = nil,
        perform action: @escaping (Notification) -> Void
    ) -> some View {
        onReceive(
            center.publisher(for: name, object: object),
            perform: action
        )
    }
}

extension NSNotification.Name {
    static let onFolderCreation = Notification.Name("onFolderCreation")
}

struct ContentView: View {
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    //Selected Category
    @State private var selectedItem: Category?
    //Selected Tab
    @State var selectedTab: String = "Home"
    
    @State var bottomSheetContentType: BottomSheetType = .newTag
    @State var isShowingBottomSheet: Bool = false
    
    @State var isTabViewShown = true
    @Environment(\.presentationMode) private var presentationMode
    
    @State var categoriesViewModel = CategoriesViewModel()
    @State var documentsViewModel = DocumentsViewModel()

    @State var isAlertShown: Bool = false

    @State var isDocumentEditPreviewShown: Bool = false
    @State var documentEditMenuType: PreviewMenuItems = .Details
    
    @StateObject var googleAuth: GoogleAuthModel =  GoogleAuthModel()
    @ObservedObject var folderViewModel = FoldersViewModel()

    
    var body: some View {
        ZStack {
            //TabView
            VStack(spacing: 0) {
                TabView(selection: $selectedTab) {
                    Home(selectedCategory: $selectedItem, bottomSheetContentType: $bottomSheetContentType, isShowingBottomSheet: $isShowingBottomSheet, isAlertShown: $isAlertShown, isTabViewShown: $isTabViewShown, isDocumentDialogShown: $isDocumentEditPreviewShown, documentsViewModel: documentsViewModel, folderViewModel: folderViewModel)
                        .tag("Home")
                    
                    QRCodeScannerView(isTabViewShown: $isTabViewShown, isShowingBottomSheet: $isShowingBottomSheet, bottomSheetContentType: $bottomSheetContentType, selectedTab: $selectedTab)
                    .tag("QR Scan")
                    
                    ScanView(scannedPages: [], isTabViewShown: $isTabViewShown, isShowingBottomSheet: $isShowingBottomSheet, bottomSheetContentType: $bottomSheetContentType, selectedTab: $selectedTab, documentViewModel: documentsViewModel) {
                        self.selectedTab = "Home"
                    }
                    .tag("Camera")
                    
                    ScanView(scannedPages: [], isTabViewShown: $isTabViewShown, isShowingBottomSheet: $isShowingBottomSheet, bottomSheetContentType: $bottomSheetContentType, selectedTab: $selectedTab, documentViewModel: documentsViewModel) {
                        self.selectedTab = "Home"
                    }
                    .tag("OCR Scan")
                    
                    ImportView(isTabViewShown: $isTabViewShown, isShowingBottomSheet: $isShowingBottomSheet, selectedTab: $selectedTab, bottomSheetContentType: $bottomSheetContentType, documentViewModel: documentsViewModel)
                    .tag("Import")
                }
                
                // Custom Tab View
                if isTabViewShown {
                    CustomTabbar(selectedTab: $selectedTab, action: {
                        isShowingBottomSheet = false
                        
                        AppSharedInstance.shared.selectedTab = selectedTab
                        // Optional: Perform any additional actions when a tab is selected
                    })
                }
            }
            .ignoresSafeArea()
            
            
            if isAlertShown {
                CustomAlertView(isActive: $isAlertShown, title: "Alert", message: "Are you sure you want to delete this item?", primaryButtonLabel: "Yes", primaryButtonAction : {
                    print("YES Action")
                   
                }, secondaryButtonLabel: "No", secondaryButtonAction: {
                    print("NO Action")
                   
                },image: Image("DeleteInfoIcon"))
            }

            if isShowingBottomSheet {
                BottomSheet(isShowingBottomSheet: $isShowingBottomSheet, content: self.createBottomSheetContentView())
            }
//            DocumentPreviewCustomDialogView(isDialogViewShowing: $isDocumentEditPreviewShown, alertType: .Details, content: self.createDocumentEditDialogView())
            
        }
        .onAppear{
            isShowingBottomSheet = false
        }
    }
}

extension ContentView {
    
    func createBottomSheetContentView() -> AnyView {
        switch bottomSheetContentType {
        case .newTag:
            return AnyView(TagCreationView(isShowingBottomSheet: $isShowingBottomSheet, createTag: { newTag in
                print(newTag)
            }, categoriesViewModel: categoriesViewModel))
        case .newFolder:
            return AnyView(FolderCreationView(isShowingBottomSheet: $isShowingBottomSheet, saveAccount: .constant(""), createFolder: { folderName in
                NotificationCenter.default.post(name: .onFolderCreation, object: nil)
            })
                .environmentObject(googleAuth)
            )
        case .folderConfirmationView:
            return AnyView(EmptyView())
//            return AnyView(FolderConfirmationView(alertType: .confirmationAlert))
        case .eraseAlertView:
            return AnyView(EmptyView()) 
//            return AnyView(FolderConfirmationView(alertType: .eraseAlert))
        case .documentPreview:
            return AnyView(DocumentPreviewView(document: DocumentModel(), isShowingBottomSheet: $isShowingBottomSheet, isDocumentEditShown: $isDocumentEditPreviewShown, documentMenuType: $documentEditMenuType))
        }
    }
}

extension ContentView {
    
    func createDocumentEditDialogView() -> AnyView {
        switch documentEditMenuType {
        case .Details:
            return AnyView(DocumentDetailsDialogView())
        case .Lock:
            return AnyView(DocumentEditLockView())
        case .Tags:
            return AnyView(DocumentsEditTagSelectionView())
//        case .Delete:
//            return nil
        default:
            return AnyView(TagCreationView(isShowingBottomSheet: $isShowingBottomSheet, createTag: { newTag in
                print(newTag)
            }, categoriesViewModel: categoriesViewModel))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}

//struct CornerRadiusStyle: ViewModifier {
//    var radius: CGFloat
//    var corners: UIRectCorner
//
//    struct CornerRadiusShape: Shape {
//
//        var radius = CGFloat.infinity
//        var corners = UIRectCorner.allCorners
//
//        func path(in rect: CGRect) -> Path {
//            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//            return Path(path.cgPath)
//        }
//    }
//
//    func body(content: Content) -> some View {
//        content
//            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
//    }
//}
