//
//  DocumentScannerView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 11/09/23.
//

import SwiftUI
import Vision
import VisionKit

struct DocumentScannerView: UIViewControllerRepresentable {
    var documentViewModel : DocumentsViewModel
    @Binding var isTabViewShown : Bool
    @Binding var isShowingBottomSheet: Bool
    @Binding var isNavigated: Bool
    @Binding var bottomSheetContentType: BottomSheetType
    @Binding var selectedTab: String

    var didFinishScanning: ((_ result: Result<[UIImage], Error>) -> Void)
    var didCancelScanning: () -> Void
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = context.coordinator
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(with: self, documentModel: documentViewModel, isTabViewShown: $isTabViewShown, isShowingBottomSheet: $isShowingBottomSheet, bottomSheetContentType: $bottomSheetContentType, isNavigated: $isNavigated, selectedTab: $selectedTab)
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var scannerView: DocumentScannerView
        var documentViewModel : DocumentsViewModel
        @Binding var isTabViewShown : Bool
        @Binding var isShowingBottomSheet: Bool
        @Binding var isNavigated: Bool
        @Binding var bottomSheetContentType: BottomSheetType
        @Binding var selectedTab: String

        init(with scannerView: DocumentScannerView, documentModel: DocumentsViewModel, isTabViewShown: Binding<Bool>, isShowingBottomSheet: Binding<Bool>, bottomSheetContentType: Binding<BottomSheetType>, isNavigated: Binding<Bool>, selectedTab: Binding<String>) {
            self.scannerView = scannerView
            self.documentViewModel = documentModel
            self._isTabViewShown = isTabViewShown
            self._isShowingBottomSheet = isShowingBottomSheet
            self._bottomSheetContentType = bottomSheetContentType
            self._isNavigated = isNavigated
            self._selectedTab = selectedTab
        }
        
        // MARK: - VNDocumentCameraViewControllerDelegate
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            var scannedPages = [UIImage]()
            
            if AppSharedInstance.shared.selectedTab == "OCR Scan" {
                scannedPages.removeAll()
                scannedPages.append(scan.imageOfPage(at: scan.pageCount-1))
            } else {
                for i in 0..<scan.pageCount {
                    scannedPages.append(scan.imageOfPage(at: i))
                }
            }
            
            scannerView.didFinishScanning(.success(scannedPages))
            controller.dismiss(animated: true, completion: nil)
            
            if AppSharedInstance.shared.selectedTab == "OCR Scan" {
                let previewView = OCRPreviewImagesView(image: scannedPages[0], isTabViewShown: $isTabViewShown, ocrText: "")
                let previewHostingController = UIHostingController(rootView: previewView)
                controller.parent?.navigationController?.pushViewController(previewHostingController, animated: true)

            } else {
                let previewView = ScannedImagePreviewView(imageNames: scannedPages, isFromScanner: true, isShowingBottomSheet: $isShowingBottomSheet, bottomSheetContentType: $bottomSheetContentType, isNavigated: $isNavigated, selectedTab: $selectedTab, isTabViewShown: $isTabViewShown, documentsViewModel: self.documentViewModel, ocrText: "")
                    
                let previewHostingController = UIHostingController(rootView: previewView)
                
                controller.parent?.navigationController?.pushViewController(previewHostingController, animated: true)
            }

        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            scannerView.didCancelScanning()
            controller.dismiss(animated: true, completion: nil)
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            scannerView.didFinishScanning(.failure(error))
            controller.dismiss(animated: true, completion: nil)
        }
    }
}
