//
//  ImportView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 05/10/23.
//

import SwiftUI
import PhotosUI

struct ImportView: View {
    @State private var selectedImportImages: [UIImage] = []

    @Binding var isTabViewShown: Bool
    @Binding var isShowingBottomSheet: Bool
    @Binding var selectedTab: String
    @Binding var bottomSheetContentType: BottomSheetType
    
    @State var isNavigated: Bool = false
    @ObservedObject var documentViewModel : DocumentsViewModel
    @State var isSelectedImages: Bool = false
    
    @ViewBuilder
    private var doneButton: some View {
      Button(action: {
          selectedTab = "Home"
      }, label: {
        Text("Save")
      })
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(selectedImportImages, id: \.self) { uiImage in
                    ImageView(uiImage: uiImage)
                }
                .padding()
            }
            .edgesIgnoringSafeArea(.bottom)
//            .navigationBarTitle(Text("Imported Images in Current Session"))
            .navigationBarItems(leading: 
                                    NavigationLink(destination: ScannedImagePreviewView(imageNames: selectedImportImages, isFromScanner: true, isShowingBottomSheet: $isShowingBottomSheet, bottomSheetContentType: $bottomSheetContentType, isNavigated: .constant(false), selectedTab: $selectedTab, isTabViewShown: $isTabViewShown, documentsViewModel: documentViewModel, ocrText: ""), isActive: $isSelectedImages) {
                                        Text("Save")
                                    }
                                    .disabled(selectedImportImages.isEmpty),
                                trailing:
                                    NavigationLink(destination: PhotoPickerView(selectedImages: $selectedImportImages)) {
                                Text("Select Photo")
                            })
        }
        .onAppear{
//            isTabViewShown = false
            isSelectedImages = false
            selectedImportImages = []
        }
        .onDisappear{
//            isTabViewShown.toggle()
            isSelectedImages = false
            selectedImportImages.removeAll()
        }
       
    }
    
    /*
    var body: some View {
        NavigationView {
            VStack {
                PhotoPickerView(selectedImages: $selectedImportImages) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        if selectedImportImages.count > 0 {
                            isSelectedImages.toggle()
                        } else {
                            selectedTab = "Home"
                        }
                    })
                }
                .background(
                    NavigationLink(destination: ScannedImagePreviewView(imageNames: selectedImportImages , isFromScanner: true, isShowingBottomSheet: $isShowingBottomSheet, bottomSheetContentType: $bottomSheetContentType, isNavigated: .constant(false), selectedTab: $selectedTab, isTabViewShown: $isShowingBottomSheet, documentsViewModel: documentViewModel), isActive: $isSelectedImages) {
                        EmptyView()      // << hidden !!
                    })

            }
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)

        }
        .onAppear{
            isTabViewShown = false
            isSelectedImages = false
            selectedImportImages = []
        }
        .onDisappear{
            isTabViewShown.toggle()
            isSelectedImages = false
            selectedImportImages.removeAll()
        }

    }
    */
}


struct PhotoPickerView: View {
    @Binding var selectedImages: [UIImage]

    var body: some View {
        PhotoPicker(imageSelection: $selectedImages)
            .navigationBarTitle("Select Photos")
    }
}

struct PhotoPicker: View {
    @Binding var imageSelection: [UIImage]

    var body: some View {
        // Implement your photo picker UI here.
        ImagePicker(selectedImages: $imageSelection)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var selectedImages: [UIImage]
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 10
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                        if let image = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.selectedImages.append(image)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ImageView: View {
  var uiImage: UIImage
  
  var body: some View {
    Image(uiImage: uiImage)
      .resizable()
      .frame(height: 250, alignment: .center)
      .aspectRatio(contentMode: .fit)
      .cornerRadius(10)
      .padding(10)
  }
}
