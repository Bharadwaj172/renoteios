//
//  DocumentPreviewCustomDialogView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 17/09/23.
//

import SwiftUI

struct DocumentPreviewCustomDialogView: View {
    @Binding var isDialogViewShowing: Bool
    @ObservedObject var keyboardObserver = KeyboardObserver()
    @State private var offset: CGFloat = 1000
    
//    var primaryButtonAction: () -> Void
    
    var alertType: PreviewMenuItems
    var content: AnyView
    
    
    var body: some View {
        ZStack {
            if (isDialogViewShowing) {
                Color(.black)
                    .opacity(0.5)
                    .onTapGesture {
                        close()
                    }
                VStack {
                    HStack {
                        
                        if let image = lefttHeaderImage {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                        }
                        Text(title)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                        
                        if let image = rightHeaderImage {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                        }
                        Spacer()
                        Button {
                            print("close action")
                            close()
                        } label: {
                            Image(systemName: "xmark.circle")
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                                .foregroundColor(Color.gray)
                        }
                    }
                    .padding(10)
                    .background(Color(hex: "#E8E8E8"))
                    
                    content
                    
                    HStack {
                        Spacer()
                        Button (action: { self.primaryButtonAction()
                            close() }) {
                            Text(primaryButtonLabel)
                                .fontWeight(.medium)
                                .padding(10)
                                .foregroundColor(.white)
                                .padding (.horizontal, 50)
                        }
                        .background(confirmButtonGradient)
                        .cornerRadius(36, corners: .allCorners)

                        Spacer()
                    }
                    .padding(10)
                    .background(Color(hex: "#E8E8E8"))
                }
                .fixedSize(horizontal: false, vertical: true)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .shadow(radius: 20)
                .padding(30)
                .offset(x: 0, y: offset)
                .onAppear {
                    withAnimation(.spring()) {
                        offset = 0
                    }
                }
            }
        }
        .ignoresSafeArea()
        
    }
    
    func close() {
        withAnimation(.spring()) {
            offset = 1000
            isDialogViewShowing.toggle()
        }
    }
}

extension DocumentPreviewCustomDialogView {
    
    var title: String {
        switch alertType {
        case .Details:
            return "File Details"
        default:
            return ""
        }
    }
    
    var primaryButtonLabel: String {
        switch alertType {
        case .Details:
            return "Close"
        default:
            return ""
        }
    }
    
    var rightHeaderImage: Image? {
        switch alertType {
        case .Delete:
            return Image(alertType.rawValue)
        default:
            return nil
        }
    }
    var lefttHeaderImage: Image? {
        switch alertType {
        case .Details:
            return Image(alertType.rawValue)
        default:
            return nil
        }
    }
    
    func primaryButtonAction() {
        
    }

    private var confirmButtonGradient: LinearGradient {
        return LinearGradient(gradient: Gradient(colors: [Color(UIColor(red: 3/255.0, green: 151/255.0, blue: 41/255.0, alpha: 1)), Color(UIColor(red: 78/255.0, green: 234/255.0, blue: 118/255.0, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
    }
    
}

//struct DocumentPreviewCustomDialogView_Previews: PreviewProvider {
//    static var previews: some View {
//        DocumentPreviewCustomDialogView(isDialogViewShowing: <#Binding<Bool>#>)
//    }
//}
