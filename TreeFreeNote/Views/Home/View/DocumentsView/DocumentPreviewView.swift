//
//  DocumentPreviewView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 14/09/23.
//
import SwiftUI

enum PreviewMenuItems : String, CaseIterable, Identifiable {
    var id: String { return self.rawValue }
    
    case Details
    case View
    case Pin
    case Tags
    case Copy
    case Move
    case Delete
    case Rename
    case Lock
    case OCR
    case Edit
    case Share
}


struct DocumentPreviewView: View {
    
    var layout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var document: DocumentModel
    @Binding var isShowingBottomSheet: Bool
    @Binding var isDocumentEditShown: Bool
    @Binding var documentMenuType: PreviewMenuItems
    
    var body: some View {
        VStack {
            DocumentListCell(document: document, isFromPreview: true, isShowingBottomSheet: $isShowingBottomSheet, bottomSheetContentType: .constant(.documentPreview), isDocumentDialogShown: $isDocumentEditShown)
//            DocumentListCell(document: $document, isFromPreview: true, isShowingBottomSheet: $isShowingBottomSheet)
                .frame(height: 80)
                .padding(10)
                .background(Color(hex: "F4F4F4"))
                .cornerRadius(25, corners: .allCorners)
                .shadow(color: Color.black.opacity(0.25), radius: 5, x: 0, y: 4)
                .shadow(color: Color.black.opacity(0.25), radius: 5, x: 0, y: 4)
                .padding(10)
                .padding(.bottom, 20)
            //            ScrollView {
            LazyVGrid(columns: layout, spacing: 20) {
                ForEach(PreviewMenuItems.allCases, id: \.id) { menuItem in
                    
                    ZStack {
                        Rectangle()
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color.clear)
                        VStack(spacing: 5) {
                            Image(menuItem.rawValue)
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio( contentMode: .fit)
                                .frame(width: 28, height: 28)
                            Text(menuItem.rawValue)
                                .font(.system(size: 12))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .onTapGesture {
                        print(menuItem)
                        self.didTapOnMenuItem(menuItem: menuItem)
                    }
                }
            }
            .padding(.horizontal, 30)
            //            }
            //            .frame(height: 200)
        }
        .padding(.bottom, 42)
        .frame(height: 380)
    }

    private func didTapOnMenuItem(menuItem: PreviewMenuItems) {
        documentMenuType = menuItem
        isDocumentEditShown.toggle()
    }
    
}

//struct DocumentPreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        DocumentPreviewView(documentInfo: .constant(Document(title: "test", creationDate: "sdjfh", fileFormat: "png")))
//    }
//}
