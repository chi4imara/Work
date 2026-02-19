import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    enum SourceType {
        case camera
        case photoLibrary
    }
    
    let sourceType: SourceType
    let onImagePicked: (UIImage) -> Void
    let onCancel: () -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        picker.sourceType = sourceType == .camera ? .camera : .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                parent.onImagePicked(image)
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.onCancel()
            picker.dismiss(animated: true)
        }
    }
}

struct PhotoLibraryPicker: UIViewControllerRepresentable {
    let onImagePicked: (UIImage) -> Void
    let onCancel: () -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoLibraryPicker
        
        init(_ parent: PhotoLibraryPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let result = results.first else {
                parent.onCancel()
                return
            }
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
                DispatchQueue.main.async {
                    if let image = object as? UIImage {
                        self?.parent.onImagePicked(image)
                    } else {
                        self?.parent.onCancel()
                    }
                }
            }
        }
    }
}
