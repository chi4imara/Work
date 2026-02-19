import SwiftUI
import UIKit

struct ImagePickerView: UIViewControllerRepresentable {
    enum SourceType {
        case camera
        case photoLibrary
        
        var uiSourceType: UIImagePickerController.SourceType {
            switch self {
            case .camera: return .camera
            case .photoLibrary: return .photoLibrary
            }
        }
    }
    
    let sourceType: SourceType
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType.uiSourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        picker.modalPresentationStyle = .fullScreen
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let edited = info[.editedImage] as? UIImage {
                parent.image = edited
            } else if let original = info[.originalImage] as? UIImage {
                parent.image = original
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

enum AvatarStorage {
    static let fileNamePrefix = "avatar_"
    
    static func saveAvatarImage(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let filename = "\(fileNamePrefix)\(UUID().uuidString).jpg"
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentsURL.appendingPathComponent(filename)
        do {
            try data.write(to: fileURL)
            return filename
        } catch {
            return nil
        }
    }
    
    static func loadAvatarImage(filename: String?) -> UIImage? {
        guard let filename = filename else { return nil }
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentsURL.appendingPathComponent(filename)
        guard FileManager.default.fileExists(atPath: fileURL.path),
              let data = try? Data(contentsOf: fileURL),
              let image = UIImage(data: data) else { return nil }
        return image
    }
    
    static func deleteAvatarImage(filename: String?) {
        guard let filename = filename else { return }
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentsURL.appendingPathComponent(filename)
        try? FileManager.default.removeItem(at: fileURL)
    }
}
