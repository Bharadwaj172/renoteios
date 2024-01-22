//
//  SegmentHeaderView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 25/06/23.
//

import SwiftUI

struct SegmentHeaderView: View {
    @State private var selectedSegment = ""

    var body: some View {
        Picker("Segments", selection: $selectedSegment) {
            ForEach(DocumentSegments.allCases, id: \.rawValue) { segment in
                Text(segment.rawValue).tag(segment)
            }
        }.pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 20)
            .onAppear {
                selectedSegment = DocumentSegments.allCases.first?.rawValue ?? ""
            }
    }
}

struct SegmentHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentHeaderView()
    }
}

enum DocumentSegments: String, CaseIterable {
    case All, Documents, Folders
}
    
