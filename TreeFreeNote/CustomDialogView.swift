//
//  CustomDialogView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 14/09/23.
//

import SwiftUI

struct CustomDialogView: View {
    @Binding var isDialogViewShowing: Bool
    @ObservedObject var keyboardObserver = KeyboardObserver()
    @State private var offset: CGFloat = 1000

    var viewTitle: String
    var buttonTitle: String
    var content: AnyView

    var body: some View {
        ZStack(alignment: .bottom) {
            if (isDialogViewShowing) {
                Color.black
                    .opacity(isDialogViewShowing ? 0.3 : 0)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isDialogViewShowing.toggle()
                        UIApplication.shared.endEditing()
                    }
                VStack {
                    HStack {
                        Text(viewTitle)
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(Color.black)
                        Spacer()
                        Button {
                            print("close action")
                            isDialogViewShowing.toggle()
                        } label: {
                            Image(systemName: "xmark.circle")
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                                .foregroundColor(Color.gray)
                                .padding(.horizontal, 10)
                        }
                    }
                    .background(Color(hex: "#E8E8E8"))
                    content
                    HStack {
                        Spacer()
                        Button {
                            print("close action")
                            isDialogViewShowing.toggle()
                        } label: {
                            Image(systemName: "xmark.circle")
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                                .foregroundColor(Color.gray)
                                .padding(.horizontal, 10)
                        }
                        Spacer()
                    }
                    .background(Color(hex: "#E8E8E8"))

                }
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 20)
                .padding(30)
                .offset(x: 0, y: offset)
                .onAppear {
                    withAnimation(.spring()) {
                        offset = 0
                    }
                }
                .padding(.bottom, keyboardObserver.keyboardHeight)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.spring(), value: isDialogViewShowing)
        .onTapGesture {
            // Dismiss the keyboard when tapping outside the text fields
            UIApplication.shared.endEditing()
        }
    }
}

//struct CustomDialogView_Previews: PreviewProvider {
//    static var previews: some View {
////        CustomDialogView(isDialogViewShowing: <#Binding<Bool>#>, content: <#AnyView#>)
//    }
//}
