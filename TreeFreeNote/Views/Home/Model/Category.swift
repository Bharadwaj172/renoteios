//
//  Category.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 29/05/23.
//

import Foundation

struct Category: Identifiable, Equatable, Hashable {
    
    var id : Int = 0
    var title: String = ""
    var isSelected: Bool = false
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.title == rhs.title
    }
    
    mutating func updateState(selectedState: Bool) {
        self.isSelected = selectedState
    }
}
