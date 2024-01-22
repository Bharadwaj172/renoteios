//
//  CategoryViewModel.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 08/08/23.
//

import Foundation

class CategoriesViewModel: ObservableObject {
    @Published var categories: [Category] = []

    init() {
        self.getCategoriesFromDB()
        /*
         if let data = UserDefaults.standard.data(forKey: categoriesTag),
           var savedItems = try? JSONDecoder().decode([Category].self, from: data) {
            for index in 0..<savedItems.count {
                savedItems[index].isSelected = (index == 0)
            }
            categories = savedItems
        } else {
            let defultCategories = [
                Category(title: "All"),
                Category(title: "Starred"),
                Category(title: "Most Viewed")]
            
            for (index, category) in defultCategories.enumerated() {
                if index == 0 {
                    var category = category
                    category.updateState(selectedState: true)
                    self.addCategory(category)
                } else {
                    self.addCategory(category)
                }
            }
        }
         */
    }
    
    func addCategory(_ category: Category) {
        categories.append(category)
        querys().insertTags(tag_name: category.title)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.getCategoriesFromDB()
        })
    }
    
    func updateStateForCategory(category: Category) {
        for index in 0..<categories.count  {
            self.categories[index].isSelected = false
            if categories[index].id == category.id {
                self.categories[index].isSelected = true
            }
        }
        objectWillChange.send()
    }
    
    func getCategoriesFromDB() {
        let categoriesInfo = querys().get_value_of_tabel(tableName: DBTableName.tags.rawValue)
        // "CREATE TABLE IF NOT EXISTS tags(Id INTEGER PRIMARY KEY, tag_name TEXT);"
        var savedItems = [Category]()
        self.categories.removeAll()
        for category in categoriesInfo {
            var categoryModel = Category()
            if let id = category["Id"] as? Int {
                categoryModel.id = id
            }
            if let title = category["tag_name"] as? String {
                categoryModel.title = title
            }
            self.categories.append(categoryModel)
        }
        if var firstItem = self.categories.first { firstItem.isSelected = true }

//        if !self.categories.isEmpty {
//            if var firstbj = self.categories.first {
//                firstbj.isSelected = true
//                self.categories[0] = firstbj
//            }
//        }
//        categories = savedItems
    }
}
