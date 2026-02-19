import SwiftUI
import PhotosUI

struct AddOutfitView: View {
    @EnvironmentObject var outfitViewModel: OutfitViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTab: TabItem
    
    @State private var name = ""
    @State private var description = ""
    @State private var selectedCategory: OutfitCategory = .casual
    @State private var isFavorite = false
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var showingActionSheet = false
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && selectedImage != nil
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            VStack {
                HStack {
                    Text("New Outfit")
                        .font(.lumierepolis(28, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            Text("Add Photo")
                                .font(.lumierepolis(18, weight: .bold))
                                .foregroundColor(.textPrimary)
                            
                            Button(action: {
                                showingActionSheet = true
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.cardBackground.opacity(0.3))
                                        .frame(height: 200)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.primaryYellow.opacity(0.5), style: StrokeStyle(lineWidth: 2, dash: [10]))
                                        )
                                    
                                    if let image = selectedImage {
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 200)
                                            .clipped()
                                            .cornerRadius(20)
                                    } else {
                                        VStack(spacing: 12) {
                                            Image(systemName: "camera.fill")
                                                .font(.system(size: 40))
                                                .foregroundColor(.primaryYellow)
                                            
                                            Text("Tap to add photo")
                                                .font(.lumierepolis(16, weight: .light))
                                                .foregroundColor(.textSecondary)
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Outfit Name")
                                    .font(.lumierepolis(16, weight: .bold))
                                    .foregroundColor(.textPrimary)
                                
                                TextField("Enter outfit name", text: $name)
                                    .font(.lumierepolis(16))
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.cardBackground.opacity(0.8))
                                    )
                                    .foregroundColor(.textDark)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Category")
                                    .font(.lumierepolis(16, weight: .bold))
                                    .foregroundColor(.textPrimary)
                                
                                HStack(spacing: 12) {
                                    ForEach(OutfitCategory.allCases, id: \.self) { category in
                                        Button(action: {
                                            selectedCategory = category
                                        }) {
                                            Text(category.displayName)
                                                .font(.lumierepolis(14, weight: .bold))
                                                .foregroundColor(selectedCategory == category ? .textDark : .textSecondary)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 10)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .fill(selectedCategory == category ? Color.primaryYellow : Color.cardBackground.opacity(0.3))
                                                )
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.lumierepolis(16, weight: .bold))
                                    .foregroundColor(.textPrimary)
                                
                                TextField("For what occasion?", text: $description, axis: .vertical)
                                    .font(.lumierepolis(16))
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.cardBackground.opacity(0.8))
                                    )
                                    .foregroundColor(.textDark)
                                    .lineLimit(3...6)
                            }
                            
                            HStack {
                                Text("Add to favorites")
                                    .font(.lumierepolis(16, weight: .bold))
                                    .foregroundColor(.textPrimary)
                                
                                Spacer()
                                
                                Toggle("", isOn: $isFavorite)
                                    .toggleStyle(SwitchToggleStyle(tint: .primaryYellow))
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.cardBackground.opacity(0.3))
                            )
                        }
                        
                        Button(action: saveOutfit) {
                            Text("Save Outfit")
                                .font(.lumierepolis(18, weight: .bold))
                                .foregroundColor(isFormValid ? .textDark : .textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(isFormValid ? Color.primaryYellow : Color.cardBackground.opacity(0.3))
                                )
                        }
                        .disabled(!isFormValid)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .confirmationDialog("Select Photo", isPresented: $showingActionSheet) {
            Button("Camera") {
                showingCamera = true
            }
            Button("Photo Library") {
                showingImagePicker = true
            }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
        }
        .sheet(isPresented: $showingCamera) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
        }
    }
    
    private func saveOutfit() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        outfitViewModel.addOutfit(
            name: trimmedName,
            description: trimmedDescription,
            category: selectedCategory,
            isFavorite: isFavorite,
            image: selectedImage
        )
        
        withAnimation {
            selectedTab = .home
            dismiss()
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    let sourceType: UIImagePickerController.SourceType
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
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
