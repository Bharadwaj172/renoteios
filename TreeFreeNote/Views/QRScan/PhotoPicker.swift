//
//  PhotoPicker.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 05/10/23.
//

import SwiftUI
import PhotosUI

/*
struct PhotoPickerView: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
    var didFinishImportingImages: () -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 10 // Set to 0 for unlimited selection

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // Update any properties or settings here if needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPickerView

        init(_ parent: PhotoPickerView) {
            self.parent = parent
            
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.selectedImages.removeAll()
            
            for image in results {
              if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
                image.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] newImage, error in
                  if let error = error {
                    print("Can't load image \(error.localizedDescription)")
                  } else if let image = newImage as? UIImage {
                    self?.parent.selectedImages.append(image)
                  }
                }
              } else {
                print("Can't load asset")
              }
            }
            
            parent.didFinishImportingImages()
          }
    }
}
*/
