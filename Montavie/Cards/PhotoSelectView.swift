//
//  PhotoSelectView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/13/22.
//

import SwiftUI
import UIKit
import PhotosUI

struct PhotoSelectView: View {
    @State private var showActionSheet = false
    @State private var isShowPhotoLibrary = false
    @State private var isShowCamera = false
    @Binding var post: Post
    
    var body: some View {
        Button(action: {showActionSheet.toggle()}) {
            if post.imageData != nil {
                ZStack(alignment: .bottomLeading) {
                    Image(uiImage: UIImage(data: post.imageData!)!)
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(Color("BrandLightGrey"))
                        .frame(minWidth: 200, maxWidth: .infinity)
                        .edgesIgnoringSafeArea(.all)
                    Image(systemName: "photo")
                        .foregroundColor(Color("LightText"))
                        .font(.system(size: 30))
                        .padding()
                }
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color("BrandLightGrey"))
                        .frame(height: 200)
                    Image(systemName: "plus")
                        .foregroundColor(Color("BrandDarkGrey"))
                        .font(.system(size: 30))
                        .padding()
                }
            }
        }
        .confirmationDialog("", isPresented: $showActionSheet, titleVisibility: .hidden) {
            Button(action: {isShowCamera.toggle()}) {
                Text("Take Picture")
            }
            Button(action: {isShowPhotoLibrary.toggle()}) {
                Text("Choose Existing")
            }
        }
        .fullScreenCover(isPresented: $isShowCamera) {
            ImageTaker(selectedImage: self.$post.imageData, date: $post.date, location: $post.location)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .background(Color.black)
        }
        .fullScreenCover(isPresented: $isShowPhotoLibrary) {
            ImagePicker(selectedImage: self.$post.imageData, date: $post.date, location: $post.location)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal)
    }
}

// from https://github.com/appcoda/ImagePickerSwiftUI
struct ImageTaker: UIViewControllerRepresentable {

    @StateObject var locationManager = LocationManager()
    @Binding var selectedImage: Data?
    @Binding var date: Date
    @Binding var location: CLLocationCoordinate2D?
    
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageTaker>) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        imagePicker.delegate = context.coordinator
        imagePicker.modalPresentationStyle = .overCurrentContext

        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImageTaker>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: ImageTaker

        init(_ parent: ImageTaker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image.jpegData(compressionQuality: 0.1)
                parent.location = parent.locationManager.lastLocation?.coordinate
                parent.date = Date()
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
        
    @Binding var selectedImage: Data?
    @Binding var date: Date
    @Binding var location: CLLocationCoordinate2D?
    
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.selectionLimit = 1
        let controller = PHPickerViewController(configuration: config)
        controller.delegate = context.coordinator
        return controller
    }
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return Coordinator(self)
    }
    
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            guard !results.isEmpty else {
                return
            }
            
            let imageResult = results[0]
            
            if let assetId = imageResult.assetIdentifier {
                let assetResults = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
                DispatchQueue.main.async {
                    self.parent.date = assetResults.firstObject?.creationDate ?? Date()
                    self.parent.location = assetResults.firstObject?.location?.coordinate
                }
            }
            if imageResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
                imageResult.itemProvider.loadObject(ofClass: UIImage.self) { (selectedImage, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        DispatchQueue.main.async {
                            let selected = selectedImage as? UIImage
                            self.parent.selectedImage = selected?.jpegData(compressionQuality: 0.1)
                        }
                    }
                }
            }
        }
        
        private let parent: ImagePicker
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
    }
}



struct PhotoSelectView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoSelectView(post: .constant(Post()))
    }
}
