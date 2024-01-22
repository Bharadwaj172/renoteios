//
//  ImageScannerControllerViewRepresenter.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 10/07/23.
//

import SwiftUI

struct ImageScannerControllerViewRepresenter: UIViewControllerRepresentable{
    var documentViewModel : DocumentsViewModel
    
    func makeUIViewController(context: Context) -> ImageScannerController {
        guard let controller=controller as? ImageScannerController else {
            return ImageScannerController(documentViewModel: documentViewModel)
        }
        controller.imageScannerDelegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: ImageScannerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator { imageResults in
            self.didFinishScanningWithResults(imageResults)
        } didClickOnScannerCancel: {
            self.didClickOnScannerCancel?()
        }
    }
    
    let controller:UIViewController?
    var didFinishScanningWithResults: (_ results: ImageScannerResults) -> Void
    var didClickOnScannerCancel: (() ->Void)?
    typealias UIViewControllerType = ImageScannerController
    
}

class Coordinator:NSObject, ImageScannerControllerDelegate {
    
    var didFinishScanningWithResults: (_ results: ImageScannerResults) -> Void
    var didClickOnScannerCancel: () -> Void?
    
    init(didFinishScanningWithResults: @escaping (_: ImageScannerResults) -> Void, didClickOnScannerCancel: @escaping () -> Void?) {
        self.didFinishScanningWithResults = didFinishScanningWithResults
        self.didClickOnScannerCancel = didClickOnScannerCancel
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        self.didFinishScanningWithResults(results)
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        self.didClickOnScannerCancel()
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        self.didClickOnScannerCancel()
    }
        
}
