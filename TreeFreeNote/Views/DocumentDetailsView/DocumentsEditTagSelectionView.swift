//
//  DocumentsEditTagSelectionView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 17/09/23.
//

import SwiftUI

struct DocumentsEditTagSelectionView: View {
    
    @State private var items: [ListItem] = [
            ListItem(id: 1, name: "Item 1", isSelected: false),
            ListItem(id: 2, name: "Item 2", isSelected: false),
            ListItem(id: 3, name: "Item 3", isSelected: false),
            ListItem(id: 4, name: "Item 1", isSelected: false),
            ListItem(id: 5, name: "Item 2", isSelected: false),
            ListItem(id: 6, name: "Item 3", isSelected: false),
            ListItem(id: 7, name: "Item 1", isSelected: false),
            ListItem(id: 8, name: "Item 2", isSelected: false),
            ListItem(id: 9, name: "Item 3", isSelected: false),
        ]
        
    var categoriesViewModel = CategoriesViewModel()
    @State private var selectedItems: [ListItem] = []
    
    var body: some View {
        /*
        ScrollView(.vertical, showsIndicators: false,content: {
            VStack(spacing: 10) {
                ForEach(categoriesViewModel.$categories){ $category in
                    Checkbox(isChecked: .constant(false), title: category.name)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .onTapGesture {
//                            toggleItemSelection(item)
                        }
                }
            }
        })
        */
        VStack {
            HStack {
                Spacer()
                Image("tagIcon")
                    .frame(width: 28, height:  28)
                Text("Create New Tag")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Color.black)
                Spacer()
            }
            
            LazyVStack()  {
                ForEach($items) { $item in
                    Checkbox(isChecked: $item.isSelected, title: item.name)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .onTapGesture {
                            toggleItemSelection(item)
                        }
                }
            }
            //                .onDisappear {
            //                    // Call the completion handler when the view disappears
            //                    let selectedIds = selectedItems.map { $0.id }
            //                    let selectedNames = selectedItems.map { $0.name }
            //                    completion(selectedIds, selectedNames)
            //                }
            
        }
    }
    
    func toggleItemSelection(_ item: ListItem) {
        if let index = selectedItems.firstIndex(where: { $0.id == item.id }) {
            selectedItems.remove(at: index)
        } else {
            selectedItems.append(item)
        }
    }
    
    func completion(_ selectedIds: [Int], _ selectedNames: [String]) {
        // Implement your completion logic here
        print("Selected IDs: \(selectedIds)")
        print("Selected Names: \(selectedNames)")
    }
}

struct DocumentsEditTagSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentsEditTagSelectionView()
    }
}

struct ListItem: Identifiable {
    let id: Int
    let name: String
    @State var isSelected: Bool
}

struct Checkbox: View {
    @Binding var isChecked: Bool
    
    var title: String

    var body: some View {
        HStack {
            Button(action: {
                isChecked.toggle()
            }) {
                HStack {
                    Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text(title)
                }
            }
            .padding(.horizontal, 10)
            Spacer()
        }
        
    }
}


