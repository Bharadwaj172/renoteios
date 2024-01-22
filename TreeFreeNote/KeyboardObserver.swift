//
//  KeyboardObserver.swift
//  keyboardHandlingSample
//
//  Created by Bhargavi on 06/09/23.
//

import SwiftUI
import Combine

class KeyboardObserver: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var keyboardHeight: CGFloat = 0
    
    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { notification in
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            }
            .map { rect in
                rect.height
            }
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat.zero }
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellables)
    }
}

