import SwiftUI
import PhotosUI

struct NewIdeaView: View {
    @EnvironmentObject var makeupStore: MakeupStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var tagsText: String = ""
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var showingImageSourceAlert = false
    
    let ideaToEditId: UUID?
    
    init(ideaToEditId: UUID? = nil) {
        self.ideaToEditId = ideaToEditId
    }
    
    private var ideaToEdit: MakeupIdea? {
        guard let id = ideaToEditId else { return nil }
        return makeupStore.ideas.first { $0.id == id }
    }
    
    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        imageSection
                        
                        formFields
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(ideaToEdit == nil ? "New Idea" : "Edit Idea")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.white)
                    .font(.bauhausMedium(16))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveIdea()
                    }
                    .foregroundColor(isFormValid ? AppColors.white : AppColors.white.opacity(0.5))
                    .font(.bauhausMedium(16))
                    .disabled(!isFormValid)
                }
            }
            .toolbarBackground(Color.clear, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .onAppear {
            loadExistingIdea()
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .fullScreenCover(isPresented: $showingCamera) {
            CameraView(image: $selectedImage)
        }
        .alert("Select Image Source", isPresented: $showingImageSourceAlert) {
            Button("Camera") {
                showingCamera = true
            }
            Button("Photo Library") {
                showingImagePicker = true
            }
            Button("Cancel", role: .cancel) { }
        }
    }
    
    private var imageSection: some View {
        VStack(spacing: 16) {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(16)
                    .overlay(
                        Button(action: { self.selectedImage = nil }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(AppColors.white)
                                .background(AppColors.darkGray.opacity(0.8))
                                .clipShape(Circle())
                        }
                        .padding(8),
                        alignment: .topTrailing
                    )
            } else {
                Button(action: { showingImageSourceAlert = true }) {
                    VStack(spacing: 12) {
                        Image(systemName: "photo.badge.plus")
                            .font(.system(size: 40))
                            .foregroundColor(AppColors.purple)
                        
                        Text("Add Photo")
                            .font(.bauhausMedium(16))
                            .foregroundColor(AppColors.purple)
                    }
                    .frame(height: 150)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppColors.purple.opacity(0.5), style: StrokeStyle(lineWidth: 2, dash: [8]))
                            .background(AppColors.white.opacity(0.1))
                    )
                }
            }
        }
    }
    
    private var formFields: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Title *")
                    .font(.bauhausMedium(16))
                    .foregroundColor(AppColors.white)
                
                TextField("Enter idea title", text: $title)
                    .font(.bauhausLight(16))
                    .foregroundColor(AppColors.darkGray)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.white.opacity(0.9))
                    )
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Tags")
                    .font(.bauhausMedium(16))
                    .foregroundColor(AppColors.white)
                
                TextField("evening, glam, party", text: $tagsText)
                    .font(.bauhausLight(16))
                    .foregroundColor(AppColors.darkGray)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.white.opacity(0.9))
                    )
                
                Text("Separate tags with commas")
                    .font(.bauhausLight(12))
                    .foregroundColor(AppColors.white.opacity(0.7))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Description / Notes")
                    .font(.bauhausMedium(16))
                    .foregroundColor(AppColors.white)
                
                TextField("Add notes about this look...", text: $description, axis: .vertical)
                    .font(.bauhausLight(16))
                    .foregroundColor(AppColors.darkGray)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .frame(minHeight: 80, alignment: .topLeading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.white.opacity(0.9))
                    )
            }
        }
    }
    
    private func loadExistingIdea() {
        guard let idea = ideaToEdit else { return }
        
        title = idea.title
        description = idea.description
        tagsText = idea.tags.joined(separator: ", ")
        selectedImage = idea.image
    }
    
    private func saveIdea() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        let tags = tagsText.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        
        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
        
        if let existingIdea = ideaToEdit {
            var updatedIdea = existingIdea
            updatedIdea.title = trimmedTitle
            updatedIdea.description = trimmedDescription
            updatedIdea.tags = tags
            updatedIdea.imageData = imageData
            
            makeupStore.updateIdea(updatedIdea)
        } else {
            let newIdea = MakeupIdea(
                title: trimmedTitle,
                imageData: imageData,
                tags: tags,
                description: trimmedDescription
            )
            
            makeupStore.addIdea(newIdea)
        }
        
        dismiss()
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
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
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.image = selectedImage
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.image = selectedImage
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

struct NewIdeaView_Previews: PreviewProvider {
    static var previews: some View {
        NewIdeaView()
            .environmentObject(MakeupStore())
    }
}
