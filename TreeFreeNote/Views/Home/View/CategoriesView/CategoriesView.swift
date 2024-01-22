//
//  CategoriesView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 29/05/23.
//

import SwiftUI

struct CategoriesView: View {
    
//    @ObservedObject
    var categoriesViewModel = CategoriesViewModel()
    @Namespace var animation

    var body: some View {
        ScrollViewReader {scrollView in
            ScrollView(.horizontal, showsIndicators: false,content: {
                HStack(spacing: 10) {
                    ForEach(categoriesViewModel.categories, id: \.self){ category in
                        Button {
                            withAnimation(.spring()) {
                                self.categoriesViewModel.updateStateForCategory(category: category)
                            }
                        } label: {
                            CategoryView(category: category)
                        }
                    }
                }
            })
            .frame(maxWidth: .infinity)
            .onChange(of: categoriesViewModel.categories) { newValue in
                if let selectedCategory = categoriesViewModel.categories.first(where: { $0.isSelected }) {
                    scrollView.scrollTo(selectedCategory, anchor: .center)
                }
            }
            .onAppear{
                self.categoriesViewModel.getCategoriesFromDB()
            }
        }
    }
}

struct CategoryView : View {
    
    var category: Category
    @Namespace var animation

    var body: some View {
        Text(category.title)
            .fontWeight(.medium)
            .foregroundColor(category.isSelected ? .white : Color.categoriesTextColor)
            .frame(minWidth: 50)
            .frame(height: 30)
            .padding(.horizontal, 10)
            .background(Color.clear)
            .clipShape(Capsule())
            .overlay(Capsule()
                .stroke(category.isSelected ? Color.clear : .gray.opacity(0.8), lineWidth: 1))
            .background(
            //For Slide Animation effect
                
                ZStack{
                    if category.isSelected {
                        Color.green
                            .clipShape(Capsule())
                            .overlay(Capsule()
                                .stroke(category.isSelected ? Color.clear : Color.categoriesTextColor.opacity(0.8), lineWidth: 1))
                            .matchedGeometryEffect(id: "Tab", in: animation)
                    }
                }
            
            )
    }
}

//struct CategoriesView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoriesView(selectedCategory: .constant( categories.first!))
//    }
//}
