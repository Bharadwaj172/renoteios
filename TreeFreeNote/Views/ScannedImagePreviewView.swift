//
//  ScannedImagePreviewView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 22/08/23.
//

import Foundation
import SwiftUI

struct ScannedImagePreviewView: View {
    var imageNames = [UIImage]()
    var isFromScanner: Bool = false

    @State var isOCRTranslated = false
    @State private var isToasterVisible = false

    @Binding var isShowingBottomSheet: Bool
    @Binding var bottomSheetContentType: BottomSheetType
    @Binding var isNavigated: Bool
    @Binding var selectedTab: String

    @Binding var isTabViewShown: Bool

    @State private var documentName: String = ""

    @State private var currentIndex: Int = 1
    @GestureState private var translation: CGFloat = 0

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @ObservedObject var documentsViewModel: DocumentsViewModel
    @State private var selectedIndex: Int? = 0

    @State var ocrText: String
    
    var body: some View {
        VStack {
            if isFromScanner {
                VStack {
                    RoundedTextField(inputText: $documentName, placeHolder: "Enter Document Name", isDropDown: false, dropDownList: [])
                        .padding(20)
                }
            }
            
            GeometryReader { proxy in
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(imageNames, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: proxy.size.height)
                                
                        }
                        .frame(width: proxy.size.width, height: proxy.size.height - 2)
                    }

                }
                .gesture(
                    DragGesture().updating(self.$translation) { value, state, _ in
                        state = value.translation.width
                    }.onEnded { value in
                        let offset = value.translation.width / proxy.size.width
                        let newIndex = (CGFloat(self.currentIndex) - offset).rounded()
                        self.currentIndex = min(max(Int(newIndex), 0), self.imageNames.count - 1)
                    }
                )
                
            }
            .background(Color.clear)
            HStack {
                if isFromScanner {
//                    CustomLogoButton(imageName: "Back") {
//                        self.presentationMode.wrappedValue.dismiss()
//                    }
                }
                
                Spacer()
                Text("\((selectedIndex ?? 0)+1) / \(imageNames.count)")
                Spacer()
                
                
                if isFromScanner {
                    NavigationLink {
                        FoldersListView(imageNames: imageNames, foldersArray: [], isTabViewShown: $isTabViewShown, isShowingBottomSheet: $isShowingBottomSheet, bottomSheetContentType: $bottomSheetContentType, isNavigate: $isNavigated, documentName: $documentName, selectedFolderName: "", selectedTab: $selectedTab)
                    } label: {
                        Text("Next")
                            .foregroundColor(Color.black)
                            .fontWeight(.medium)
                        
                    }
                    .onTapGesture {
                        showToast()
                    }
                }
            }
            .frame(height: 55)
            .padding()
            .background(Color.clear)
            .cornerRadius(25, corners: [.topLeft,.topRight])
            
            if !isFromScanner {
                DocumentPreviewOCRView(OCRAction: {
                    self.translateTOOCR()
                }, shareAction: {
                    shareOCRData()
                })
                .frame(height: 45)
                .padding(.bottom, self.isOCRTranslated ? -8 : -32)

                if self.isOCRTranslated {
                    ScrollView {
                        Text(ocrText)
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                    }
                }
            }
            
            
            if isToasterVisible {
                Text("Please enter document Name")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .transition(.move(edge: .top))
                    .animation(.easeIn)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            hideToast()
                        }
                    }
            }
        }
        .onAppear {
            UIScrollView.appearance().isPagingEnabled = true
            isTabViewShown = false
        }
        .onDisappear{
            if !isFromScanner {
                isTabViewShown = true//.toggle()
            }
            isShowingBottomSheet = false
        }
    }
    /*
    private func saveImagesToFileDirectory() {
        let documentHandler = DocumentHandler()
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        let dateString = formatter.string(from: date)
        
        for image in self.imageNames {
            if let imagePath = documentHandler.saveImageToDocumentDirectory(selectedFolder: "", image: image) {
                let documentModel = Document(title: imagePath, creationDate: dateString, fileFormat: "Png")
                documentsViewModel.addDocument(documentModel)
            }
        }
        
    }
     */
    
    private func translateTOOCR() {
        
        if let scanImage = imageNames.first {
            let recognizer = TextRecognizer(cameraScan: scanImage)
            recognizer.recognizeText(scannedImage: scanImage) { convertedText in
                print(convertedText)
                self.isOCRTranslated = true
                if let convertedData = convertedText.first {
                    self.ocrText = convertedData
                }
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
    
    private func showToast() {
        if documentName.isEmpty {
            isToasterVisible = true
        }
    }
    
    private func hideToast() {
        isToasterVisible = false
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct DocumentPreviewOCRView: View {
    
    var OCRAction: (() -> Void)
    var shareAction: (() -> Void)
    @State var isOCRSelected: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                
                Button(action: {
                    withAnimation {
                        self.OCRAction()
                        isOCRSelected = true
                    }
                }) {
                    VStack(spacing: 5) {
                        Image("OCR")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio( contentMode: .fit)
                            .frame(width: 28, height: 28)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                }
                               
                if isOCRSelected {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            shareAction()
                        }
                    }) {
                        VStack(spacing: 5) {
                            Image("share")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio( contentMode: .fit)
                                .frame(width: 28, height: 28)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                }
                Spacer()
            }
        }
        .padding(.horizontal, 15)
        .frame(height: 45)
        .background(
            Color.green
        )
        .cornerRadius(36, corners: [.topLeft, .topRight])
    }
}

struct DocumentPreviewOCRView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentPreviewOCRView(OCRAction: {}, shareAction: {})
    }
}
