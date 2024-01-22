//
//  OCRPreviewImagesView.swift
//  TreeFreeNote
//
//  Created by Baby on 04/11/23.
//

import Foundation
import SwiftUI

struct OCRPreviewImagesView: View {
    var image = UIImage()
    var isFromScanner: Bool = false
    
    @Binding var isTabViewShown: Bool

    @State var ocrText: String
    
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
            
            VStack {
                HStack {
                    Text("Converted Text")
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                    Spacer()
                    CustomLogoButton(imageName: "share") {
                        shareOCRData()
                    }
                    .padding(.trailing, 20)
                }
                .frame(height: 45)
                .background(
                    Color.green
                )
                .cornerRadius(36, corners: [.topLeft, .topRight])
                ScrollView {
                    Text(ocrText)
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                }
                .frame(height: 300)
            }
        }
        .onAppear {
            isTabViewShown = false
            self.translateTOOCR()
        }
        
    }
    
    private func translateTOOCR() {
        let recognizer = TextRecognizer(cameraScan: image)
        recognizer.recognizeText(scannedImage: image) { convertedText in
            print(convertedText)
            if let convertedData = convertedText.first {
                self.ocrText = convertedData
            }
        }
    }
    
    private func shareOCRData() {
        let shareActivity = UIActivityViewController(activityItems: [self.ocrText], applicationActivities: nil)
        if let vc = UIApplication.shared.windows.first?.rootViewController{
            shareActivity.popoverPresentationController?.sourceView = vc.view
            //Setup share activity position on screen on bottom center
            shareActivity.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height, width: 0, height: 0)
            shareActivity.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
            vc.present(shareActivity, animated: true, completion: nil)
        }
    }
}
