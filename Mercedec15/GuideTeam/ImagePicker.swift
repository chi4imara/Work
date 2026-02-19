import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss
    
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
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.dismiss()
            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self) else { return }
            provider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
                DispatchQueue.main.async {
                    self?.parent.image = object as? UIImage
                }
            }
        }
    }
}

enum ImageStorage {
    static let salonPrefix = "salon_"
    static let avatarFilename = "profile_avatar.jpg"
    
    static var documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static func saveSalonImage(_ image: UIImage, salonId: UUID) -> String? {
        let filename = "\(salonPrefix)\(salonId.uuidString).jpg"
        return saveImage(image, filename: filename) ? filename : nil
    }
    
    static func saveAvatarImage(_ image: UIImage) -> String? {
        saveImage(image, filename: avatarFilename) ? avatarFilename : nil
    }
    
    private static func saveImage(_ image: UIImage, filename: String) -> Bool {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return false }
        let url = documentsURL.appendingPathComponent(filename)
        do {
            try data.write(to: url)
            return true
        } catch {
            return false
        }
    }
    
    static func loadImage(filename: String) -> UIImage? {
        guard !filename.isEmpty else { return nil }
        let url = documentsURL.appendingPathComponent(filename)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
}

struct LoadedImageView: View {
    let filename: String?
    let placeholder: () -> AnyView
    
    init(filename: String?, @ViewBuilder placeholder: @escaping () -> some View) {
        self.filename = filename
        self.placeholder = { AnyView(placeholder()) }
    }
    
    var body: some View {
        if let filename = filename, let uiImage = ImageStorage.loadImage(filename: filename) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            placeholder()
        }
    }
}
