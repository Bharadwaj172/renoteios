//
//  NewTagCreationView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 16/06/23.
//

import SwiftUI
import Combine

struct TagCreationView: View {
    @State private var tagName: String = ""
    @Binding var isShowingBottomSheet: Bool

    var createTag: ((String) -> ())?
    @ObservedObject var categoriesViewModel: CategoriesViewModel

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    print("close action")
                    isShowingBottomSheet = false //.toggle()
                } label: {
                    Image(systemName: "xmark.circle")
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color.gray)
                        .padding(.horizontal, 10)
                }
            }
            .padding(.bottom, -15)
            
            HStack(alignment: .center, spacing: 2) {
                Image(systemName: "tag.fill")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35, height: 35)
                Text("New Tag")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(Color.black)
            }
            .padding(.bottom, 10)
            
            HStack(alignment: .center, spacing: 0) {
                TextField("", text: $tagName)
                    .modifier(PlaceholderStyle(showPlaceHolder: tagName.isEmpty,
                                placeholder: "Enter Name"))
                    .foregroundColor(Color.black)
                Button {
                    if tagName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        print("Empty tag ALert")
                    } else {
                        self.createTag?(tagName)
                        categoriesViewModel.addCategory(Category(title: tagName))
                        isShowingBottomSheet = false//.toggle()
                    }
                } label: {
                    HStack {
                        Image(systemName: "xmark.circle")
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.white)
                            .frame(height: 35)
                            .padding(.horizontal, -5)
                        Text("Create")
                            .font(.title3)
                            .fontWeight(.regular)
                            .foregroundColor(Color.white)

                    }
                    .padding(.horizontal, 15)
                    .background(LinearGradient(gradient: Gradient(colors: [Color(UIColor(red: 3/255.0, green: 151/255.0, blue: 41/255.0, alpha: 1)), Color(UIColor(red: 78/255.0, green: 234/255.0, blue: 118/255.0, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(20, corners: [.topRight, .bottomRight])
                    
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.gray.opacity(0.5), lineWidth: 1)
                )
            .padding(.horizontal, 30)
            .frame(height: 40)
        }
        .padding(.bottom, 42)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

//struct NewTagCreationView_Previews: PreviewProvider {
//    static var previews: some View {
////        TagCreationView(isShowing: )
//    }
//}
