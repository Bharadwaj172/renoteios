//
//  DocumentListCell.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 30/05/23.
//

import SwiftUI

struct DocumentListCell: View {
    var document: DocumentModel
    var isFromPreview: Bool = false
    @Binding var isShowingBottomSheet: Bool
    @Binding var bottomSheetContentType: BottomSheetType
    @Binding var isDocumentDialogShown: Bool
    
    var body: some View {
        HStack(spacing: 2, content: {
            ZStack {
                HStack {
                    Image(uiImage: (self.loadImage() ?? UIImage(named: "Document"))!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .allowsHitTesting(false)
                        .padding(2)
                }
//                .padding(.all, 10)
                .background(Color.gray.opacity(0.5))
                .padding(.leading, 10)
//                BadgeView(title: "222", padding: 5, radius: 0, rotation: 0, xOffset: 30, yOffset: -35)
//                    .frame(width: 50, height: 25)
            }
            VStack(spacing: 2) {
                documentNameRowView
                dateRowView
                cloudAcountRowView
            }
        })
        .listRowBackground(Color.clear)
    }
    
    private func loadImage() -> UIImage? {
        return DocumentHandler().loadImageFromDocumentDirectory(fileName: self.document.imageName)
    }
}

//struct DocumentListCell_Previews: PreviewProvider {
//    static var previews: some View {
//        DocumentListCell(document: documentModelSamples.first!)
//    }
//}

private extension DocumentListCell {
    
    private var documentNameRowView: some View {
        HStack(alignment: .top) {
            Text((document.name as NSString).lastPathComponent)
                .font(.subheadline)
                .fontWeight(.medium)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.primary)
                .padding(.horizontal, 5)
            
            Spacer()
            /*
            CustomLogoButton(imageName: isFromPreview ? "Close" : "share") {
                print("share action")
                if isFromPreview {
                    isShowingBottomSheet.toggle()
                }
                
            }
            .onTapGesture {
                print("share action")
            }
            .padding(.horizontal,5)
             */
        }
    }
    
    private var dateRowView: some View {
        HStack(alignment: .center) {
            Text(document.dateCreated)
                .font(.subheadline)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.descriptionTextColor)
                .padding(.horizontal, 5)
            Spacer()
            Text(document.documentType)
                .font(.system(size: 10,weight: .light))
                .padding(.horizontal, 10)
                .frame(height: 25)
                .background(Color.descriptionTextColor.opacity(0.15))
                .foregroundColor(Color.secondaryTextColor)
                .clipShape(Capsule())
                .padding(.horizontal, 5)
        }
    }
    
    private var cloudAcountRowView: some View {
        HStack(alignment: .center) {
            HStack{
//                Image("driveIcon")
//                    .resizable()
//                    .font(.footnote)
//                    .aspectRatio(CGSize(width: 15, height: 15), contentMode: .fit)
//                    .frame(width: 20, height: 20)
                
//                Text(document.cloudAccount)
                Text("Device")
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color.secondaryTextColor)
            }
            .frame(height: 20)
            .padding(.bottom, 2)
            .padding(.horizontal, 5)
            Spacer(minLength: 5)
            
            HStack(spacing: 5){
                CustomLogoButton(imageName: "syncIcon") {
                    print("sync action")
                }
                .onTapGesture {
                    print("sync action")
                }
                
                CustomLogoButton(imageName: "star") {
                    print("starred action")
                }
                .onTapGesture {
                    print("starred action")
                }
                /*
                if !isFromPreview {
                    CustomLogoButton(imageName: "moreIcon") {
                        print("more action")
                        bottomSheetContentType = .documentPreview
                        isShowingBottomSheet.toggle() // bottom Sheet
                    }
                    .onTapGesture {
                        print("more action")
                        bottomSheetContentType = .documentPreview
                        isShowingBottomSheet.toggle() // bottom Sheet
                    }
                }
                 */
            }
        }
    }
}

struct BadgeView: View {
    var title: String
    var padding: CGFloat
    var radius: CGFloat
    var rotation: Double
    var xOffset: CGFloat
    var yOffset: CGFloat
    
    var body: some View {
        Text(title)
            .font(.callout)
            .fontWeight(.bold)
            .multilineTextAlignment(.trailing)
            .padding(padding)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(radius)
            .rotationEffect(.degrees(rotation))
            .offset(x: xOffset, y: yOffset)
    }
}

struct BlueButtonStyle: ButtonStyle {

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
        .font(.headline)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .contentShape(Rectangle())
        .foregroundColor(configuration.isPressed ? Color.white.opacity(0.5) : Color.white)
        .listRowBackground(configuration.isPressed ? Color.blue.opacity(0.5) : Color.blue)
  }
}
