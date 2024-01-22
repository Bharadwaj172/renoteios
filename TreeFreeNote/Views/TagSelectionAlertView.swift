////
////  TagSelectionAlertView.swift
////  TreeFreeNote
////
////  Created by Bhargavi on 04/09/23.
////
//
//import SwiftUI
//
//
//struct TagSelectionAlertView: View {
//    @State private var isShowingAlert = false
//    @State private var selectedItems: Set<String> = []
//
//    let items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
//
//    var body: some View {
//        Button("Show Alert") {
//            isShowingAlert.toggle()
//        }
//        .alert(isPresented: $isShowingAlert) {
//            Alert(
//                title: Text("Select Items"),
//                message: Text("Choose one or more items"),
//                primaryButton: .default(Text("Done")) {
//                    // Handle the selected items here
//                    for item in selectedItems {
//                        print("Selected Item: \(item)")
//                    }
//                },
//                secondaryButton: .cancel()
//            ) {
//                List(items, id: \.self, selection: $selectedItems) { item in
//                    Text(item)
//                }
//            }
//        }
//    }
//}
