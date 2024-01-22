//
//  CustomAlertView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 14/09/23.
//

import SwiftUI

struct CustomAlertView: View {
    @Binding var isActive: Bool
    @State private var offset: CGFloat = 1000

    var title: String?
    var message: String?
    var primaryButtonLabel: String
    var primaryButtonAction: () -> Void
    var secondaryButtonLabel: String?
    var secondaryButtonAction: (() -> Void)?
    var image: Image?
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    close()
                }
            VStack {
                HStack {
                    Spacer()
                    Button {
                        print("close action")
                        close()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color.gray)
                            .padding(.horizontal, 10)
                    }
                }
                .padding(-10)
                
                if let image = image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                } else if let title = title{
                    Text(title)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                }
                if let message = message {
                    Text(message)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                HStack {
                    Button(action: {
                        self.primaryButtonAction()
                        close()
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.red)
                                .frame(height: 40)
                            
                            Text(primaryButtonLabel)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                    })
                    if let secondaryButtonLabel = secondaryButtonLabel {
                        Button(action: {
                            self.secondaryButtonAction?()
                            close()
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(.red)
                                    .frame(height: 40)
                                
                                Text(secondaryButtonLabel)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                            }
                            
                        })
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
//            .overlay {
//                Button {
//                    close()
//                } label: {
//                    Image(systemName: "xmark")
//                        .font(.title2)
//                        .fontWeight(.medium)
//                }
//                .tint(.black)
//                .padding()
//            }
            .shadow(radius: 20)
            .padding(30)
            .offset(x: 0, y: offset)
            .onAppear {
                withAnimation(.spring()) {
                    offset = 0
                }
            }
            
        }
        .ignoresSafeArea()
    }
    
    func close() {
        withAnimation(.spring()) {
            offset = 1000
            isActive.toggle()
        }
    }
}
