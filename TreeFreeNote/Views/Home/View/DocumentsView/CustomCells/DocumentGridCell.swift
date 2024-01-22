//
//  DocumentGridCell.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 01/06/23.
//

import SwiftUI

struct DocumentGridCell: View {
    var document: DocumentModel
    var body: some View {
        VStack {
            HStack {
                ForEach(0..<2) { items in
//                    Spacer()
                    VStack(content: {
                        Image("pn_card")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
//                            .foregroundColor(.gray)
                            .background(Color.gray)
                        documentPropertiewView
                    })
//                    .frame(width: (UIScreen.main.bounds.size.width/2)-10)
                    .background(Color.green)
                    .cornerRadius(10.0, corners: .allCorners)
//                    .padding(.trailing, 5)
//                    .padding(.leading, 5)
//                    .padding(.top, 5)
//                    Spacer()
                }
            }
        }
    }
}


//struct DocumentGridCell_Previews: PreviewProvider {
//    static var previews: some View {
//        DocumentGridCell(document: documentModelSamples.first!)
//    }
//}

//
private extension DocumentGridCell {
    var documentPropertiewView: some View {
        VStack(spacing: 0, content: {
                Text(document.name)
//                    .font(.subheadline)
                    .fontWeight(.light)
                    .font(Font.system(size: 10))
//                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
//                    .background(Color.red)
            HStack(spacing: 20){
//                Spacer()
                CustomLogoButton(imageName: "share") {
                    print("share action")
                }
                CustomLogoButton(imageName: "syncIcon") {
                    print("syncIcon action")
                }
                CustomLogoButton(imageName: "star") {
                    print("starred action")
                }
                CustomLogoButton(imageName: "moreIcon") {
                    print("more action")
                }
//
//                Button(action: {
//                    print("more action")
//                }) {
//                    Image("moreIcon")
//                        .resizable()
//                        .renderingMode(.template)
//                        .aspectRatio(contentMode: .fit)
//                        .font(.footnote)
//                        .foregroundColor(.black)
//                        .padding(8)
//                        .frame(width: 30, height: 30, alignment: .center)
//                }
            }
            .frame(width: UIScreen.main.bounds.size.width/2)
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
        })
        .frame(width: UIScreen.main.bounds.size.width/2)
        .background(Color.yellow)
//        .shadow(radius: 5)
//        .cornerRadius(5, corners: .allCorners)
//        .padding(.trailing, 0)
//        .padding(.leading, 0)
    }
}

