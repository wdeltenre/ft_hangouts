//
//  EditContactHelpers.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

import Foundation
import SwiftUI
import PhotosUI
import UIKit

extension UIImage {
    func resized(to newSize: CGSize) -> UIImage {
        let widthRatio = newSize.width / size.width
        let heightRatio = newSize.height / size.height
        
        let scaleFactor = max(widthRatio, heightRatio)
        
        let scaledSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        return renderer.image { _ in
            let x = (newSize.width - scaledSize.width) / 2.0
            let y = (newSize.height - scaledSize.height) / 2.0
            
            self.draw(in: CGRect(x: x, y: y, width: scaledSize.width, height: scaledSize.height))
        }
    }
}

struct ProfileImagePicker: UIViewControllerRepresentable {
    @Binding var contact: Contact

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ProfileImagePicker

        init(_ parent: ProfileImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self)
            else { return }

            provider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                guard let self = self, let uiImage = image as? UIImage else { return }
                
                let resizedImage = uiImage.resized(to: CGSize(width: 300, height: 300))
                
                if let compressedData = resizedImage.jpegData(compressionQuality: 0.6) {
                    self.parent.contact.imageData = compressedData
                }
            }
        }
    }
}
