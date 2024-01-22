//
//  BottomSheet.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 16/06/23.
//

import SwiftUI

enum BottomSheetType: Int {
    case newTag
    case newFolder
    case folderConfirmationView
    case eraseAlertView
    case documentPreview
}

struct BottomSheet: View {

    @Binding var isShowingBottomSheet: Bool
    @ObservedObject var keyboardObserver = KeyboardObserver()

    var content: AnyView
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if (isShowingBottomSheet) {
                Color.black
                    .opacity(isShowingBottomSheet ? 0.3 : 0)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowingBottomSheet = false //.toggle()
                        UIApplication.shared.endEditing()
                    }
                content
                    .transition(.move(edge: .bottom))
                    .background(
                        Color(.white)
                    )
                    .cornerRadius(36, corners: [.topLeft, .topRight])
                    .padding(.bottom, keyboardObserver.keyboardHeight)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.spring(), value: isShowingBottomSheet)
        .onTapGesture {
            // Dismiss the keyboard when tapping outside the text fields
            UIApplication.shared.endEditing()
        }
    }
}


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//struct ObservedHolder<T: ObservableObject, Content: View>: View {
//    @ObservedObject var value: T
//    var content: (ObservedObject<T>.Wrapper) -> Content
//
//    var body: some View {
//        content(_value.projectedValue)
//    }
//}
