//
//  ScanView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 01/07/23.
//

import SwiftUI
import GoogleSignIn

struct ScanView: View {
    @State var scannedPages: [String]
    @Binding var isTabViewShown: Bool
    @Binding var isShowingBottomSheet: Bool
    @Binding var bottomSheetContentType: BottomSheetType
    @Binding var selectedTab: String
    
    @State var isNavigated: Bool = false
    @ObservedObject var documentViewModel : DocumentsViewModel

    let backAction: () -> Void

    var body: some View {
        NavigationView {
            VStack{
                self.makeScannerView()
            }
            .onAppear{
                isTabViewShown = false
                isNavigated.toggle()
            }
            .onDisappear{
                isTabViewShown = true//.toggle()
                // Dismiss the document scanner view
                // It will remove scanned images from the scannedImages array
                // Clear previous images
                self.scannedPages.removeAll()
            }
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func makeImageControllerScanner()-> ImageScannerControllerViewRepresenter {
        ImageScannerControllerViewRepresenter(documentViewModel: documentViewModel, controller: ImageScannerController(documentViewModel: documentViewModel)) { results in
            print("Scan resultss -- \(results)")
            
            guard let image = results.enhancedScan?.image else { return }
            if let imagePath = DocumentHandler().saveImageToDocumentDirectory(selectedFolder:"", image: image) {
                self.scannedPages.append(imagePath)
            }
            
//                self.backAction()
        } didClickOnScannerCancel: {
            print("cancel")
            self.backAction()
        }
    }
    
    private func makeScannerView()-> DocumentScannerView {
        DocumentScannerView(documentViewModel: documentViewModel, isTabViewShown: $isTabViewShown, isShowingBottomSheet: $isShowingBottomSheet, isNavigated: $isNavigated, bottomSheetContentType: $bottomSheetContentType, selectedTab: $selectedTab) { result in
            switch result {
            case .success(let scannedImages): break
//                self.saveImagesToFileDirectory(scannedPages: scannedImages)
                
//                self.navigateToFoldersListView(scannedPages: scannedImages)
            case .failure(let error):
                print(error.localizedDescription)
                self.backAction()
            }
        } didCancelScanning: {
            // Dismiss the scanner controller and the sheet.
            self.backAction()
        }
    }
    
    func navigateToFoldersListView(scannedPages: [UIImage]) {
        NavigationLink(destination: EmptyView()) {
            HStack {
                Text("")
            }
        }
    }
    /*
    private func saveImagesToFileDirectory(scannedPages: [UIImage]) {
        let documentHandler = DocumentHandler()
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        let dateString = formatter.string(from: date)
        
        for image in scannedPages {
            if let imagePath = documentHandler.saveImageToDocumentDirectory(selectedFolder: "", image: image) {
                let documentModel = Document(title: imagePath, creationDate: dateString, fileFormat: "Png")
                documentViewModel.addDocument(documentModel)
            }
        }
        
    }
     */
    
    
}

//struct ScanView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScanView(scannedPages: [], isTabViewShown: . constant(false), documentViewModel: DocumentsViewModel(), backAction: {
//        })
//    }
//}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
