//
//  RoundedTextField.swift
//  CustomBottomSheet
//
//  Created by Bhargavi on 20/06/23.
//

import SwiftUI

struct RoundedTextField: View {
    @Binding var inputText: String //= ""
    @State var value = ""

    var placeHolder: String
    var isDropDown: Bool
    var dropDownList: [String] 
    var body: some View {
        if isDropDown {
            Menu {
                ForEach(dropDownList, id: \.self){ client in
                    Button(client) {
                        self.value = client
                        if client == "GoogleDrive" {
                            FolderCreationObserver.shared.isStorageTypeModified = client
                        }
                    }

                }
            } label: {
                VStack(spacing: 5){
                    HStack{
                        Text(value.isEmpty ? placeHolder : value)
                            .foregroundColor(value.isEmpty ? .gray : .black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(Color.green)
                            .font(Font.system(size: 20, weight: .bold))
                    }
                    .frame(height: 30)
                    .padding(.horizontal, 5)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.gray.opacity(0.5), lineWidth: 1)
                    )
                }
            }
        } else {
            TextField("", text: $inputText)
                .modifier(PlaceholderStyle(showPlaceHolder: inputText.isEmpty,
                                           placeholder: placeHolder))
                .foregroundColor(Color.black)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.gray.opacity(0.5), lineWidth: 1)
                )
        }
    }
}

//struct RoundedTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        RoundedTextField(placeHolder: "Enter Name")
//    }
//}
