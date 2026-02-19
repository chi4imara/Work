import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    let sourceType: UIImagePickerController.SourceType
    let onImagePicked: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = true
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
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

enum AvatarStorage {
    static let fileName = "profile_avatar.jpg"
    
    static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static var avatarURL: URL {
        documentsDirectory.appendingPathComponent(fileName)
    }
    
    static func save(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        do {
            try data.write(to: avatarURL)
            return fileName
        } catch {
            return nil
        }
    }
    
    static func loadImage(path: String) -> UIImage? {
        guard !path.isEmpty else { return nil }
        let url = path.hasPrefix("/") ? URL(fileURLWithPath: path) : documentsDirectory.appendingPathComponent(path)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
}

struct AvatarImageView: View {
    let path: String
    
    var body: some View {
        Group {
            if let uiImage = AvatarStorage.loadImage(path: path) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(systemName: "person.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
        }
    }
}
