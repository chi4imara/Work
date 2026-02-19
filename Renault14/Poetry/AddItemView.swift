import SwiftUI

struct AddItemView: View {
    @EnvironmentObject var viewModel: WardrobeViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var selectedCategory = ""
    @State private var color = ""
    @State private var size = ""
    @State private var comment = ""
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    
    private var isFormValid: Bool {
        !name.isEmpty && !selectedCategory.isEmpty && !color.isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.gradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 12) {
                            Button(action: { showingImagePicker = true }) {
                                if let selectedImage = selectedImage {
                                    Image(uiImage: selectedImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 120)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                } else {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(AppColors.cardBackground)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 120)
                                        .overlay(
                                            VStack(spacing: 8) {
                                                Image(systemName: "camera.fill")
                                                    .font(.system(size: 24))
                                                    .foregroundColor(AppColors.primary)
                                                Text("Add Photo")
                                                    .font(.ubuntu(12))
                                                    .foregroundColor(AppColors.textSecondary)
                                            }
                                        )
                                }
                            }
                            .padding(.horizontal, 20)
                            .shadow(color: AppColors.shadow, radius: 8, x: 0, y: 2)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 16) {
                            FormField(title: "Item Name *", text: $name, placeholder: "Enter item name")
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Category *")
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Menu {
                                    ForEach(viewModel.categories, id: \.id) { category in
                                        Button(category.name) {
                                            selectedCategory = category.name
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedCategory.isEmpty ? "Select category" : selectedCategory)
                                            .font(.ubuntu(16))
                                            .foregroundColor(selectedCategory.isEmpty ? AppColors.textSecondary : AppColors.textPrimary)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 12))
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.cardBackground)
                                    )
                                }
                            }
                            
                            FormField(title: "Color *", text: $color, placeholder: "Enter color")
                            
                            FormField(title: "Size", text: $size, placeholder: "Enter size (optional)")
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Comment")
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                TextField("Add a comment (optional)", text: $comment, axis: .vertical)
                                    .font(.ubuntu(16))
                                    .foregroundColor(AppColors.textPrimary)
                                    .lineLimit(3...6)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.cardBackground)
                                    )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationTitle("New Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveItem()
                    }
                    .foregroundColor(isFormValid ? AppColors.primary : AppColors.textSecondary)
                    .disabled(!isFormValid)
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
    
    private func saveItem() {
        var imageName: String? = nil
        if let image = selectedImage, let savedName = ImageStorage.saveOutfitImage(image) {
            imageName = savedName
        }
        
        let item = WardrobeItem(
            name: name,
            category: selectedCategory,
            color: color,
            size: size.isEmpty ? nil : size,
            imageName: imageName,
            comment: comment.isEmpty ? nil : comment
        )
        
        viewModel.addItem(item)
        dismiss()
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
            
            TextField(placeholder, text: $text)
                .font(.ubuntu(16))
                .foregroundColor(AppColors.textPrimary)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                )
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
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
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    AddItemView()
        .environmentObject(WardrobeViewModel())
}
