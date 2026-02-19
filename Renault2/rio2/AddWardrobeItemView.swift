import SwiftUI

struct AddWardrobeItemView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var selectedCategory = WardrobeItem.ClothingCategory.tops
    @State private var size = ""
    @State private var color = ""
    @State private var notes = ""
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("New Item")
                                .font(.ubuntu(28, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            Text("Add a new piece to your wardrobe")
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.secondaryText)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            PhotoSelectionView(selectedImage: $selectedImage, showingImagePicker: $showingImagePicker)
                            
                            FormField(title: "Name", text: $name, placeholder: "Enter item name")
                            
                            CategorySelectionView(selectedCategory: $selectedCategory)
                            
                            HStack(spacing: 16) {
                                FormField(title: "Size", text: $size, placeholder: "S, M, L...")
                                    .frame(maxWidth: .infinity)
                                
                                FormField(title: "Color", text: $color, placeholder: "Blue, Red...")
                                    .frame(maxWidth: .infinity)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notes")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(AppColors.primaryText)
                                
                                TextField("Optional notes...", text: $notes, axis: .vertical)
                                    .font(.ubuntu(14))
                                    .foregroundColor(AppColors.primaryText)
                                    .padding(16)
                                    .background(AppColors.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.cardBorder, lineWidth: 1)
                                    )
                                    .cornerRadius(12)
                                    .lineLimit(3...6)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 16) {
                            Button {
                                saveItem()
                            } label: {
                                Text("Save Item")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(AppColors.accentText)
                                    .padding(.horizontal, 32)
                                    .padding(.vertical, 16)
                                    .frame(maxWidth: .infinity)
                                    .background(AppColors.yellow)
                                    .cornerRadius(25)
                            }
                            .disabled(!isFormValid)
                            .opacity(isFormValid ? 1.0 : 0.6)
                            
                            Button("Cancel") {
                                dismiss()
                            }
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.secondaryText)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
    
    private func saveItem() {
        let newItem = WardrobeItem(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            size: size.trimmingCharacters(in: .whitespacesAndNewlines),
            color: color.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        appState.addWardrobeItem(newItem)
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        dismiss()
    }
}

struct PhotoSelectionView: View {
    @Binding var selectedImage: UIImage?
    @Binding var showingImagePicker: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Photo")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: { showingImagePicker = true }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(AppColors.cardBorder, style: StrokeStyle(lineWidth: 2, dash: [5, 5]))
                        )
                        .frame(height: 120)
                        .frame(maxWidth: .infinity)
                    
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 120)
                            .clipped()
                            .cornerRadius(16)
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 32))
                                .foregroundColor(AppColors.secondaryText)
                            
                            Text("Add Photo")
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(AppColors.secondaryText)
                        }
                    }
                }
            }
        }
    }
}

struct CategorySelectionView: View {
    @Binding var selectedCategory: WardrobeItem.ClothingCategory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Category")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                ForEach(WardrobeItem.ClothingCategory.allCases, id: \.self) { category in
                    CategoryButton(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
        }
    }
}

struct CategoryButton: View {
    let category: WardrobeItem.ClothingCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? AppColors.accentText : AppColors.primaryText)
                
                Text(category.rawValue)
                    .font(.ubuntu(10, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.accentText : AppColors.primaryText)
            }
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(isSelected ? AppColors.yellow : AppColors.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? AppColors.yellow : AppColors.cardBorder, lineWidth: 1)
            )
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            TextField(placeholder, text: $text)
                .font(.ubuntu(14))
                .foregroundColor(AppColors.primaryText)
                .padding(16)
                .background(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
                .cornerRadius(12)
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
    AddWardrobeItemView()
        .environmentObject(AppState())
}
