//
//  DocumentDetailsDialogView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 17/09/23.
//

import SwiftUI

struct DocumentDetailsDialogView: View {
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 10, pinnedViews: .sectionHeaders) {
            ForEach(0..<7){ index in
                DocumentDetailsDialogViewCell()
            }
        }
        .padding(.vertical, 10)
    }
}

struct DocumentDetailsDialogView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentDetailsDialogView()
    }
}

struct DocumentDetailsDialogViewCell: View {
    var body: some View {
        HStack {
            Text("Hello, World!")
            Spacer()
            Text(":")
            Spacer()
            Text("Hello, World!")
        }
        .padding(.horizontal, 20)
        
    }
}
