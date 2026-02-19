import SwiftUI

struct AddOutfitView: View {
    var defaultName: String? = nil
    
    @EnvironmentObject var viewModel: WardrobeViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var category = ""
    @State private var selectedItems: Set<UUID> = []
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    
    private var isFormValid: Bool {
        !name.isEmpty
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
                            FormField(title: "Outfit Name *", text: $name, placeholder: "Enter outfit name")
                            
                            FormField(title: "Category", text: $category, placeholder: "Enter category (optional)")
                            
                            if !viewModel.wardrobeItems.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Select Items")
                                        .font(.ubuntu(18, weight: .medium))
                                        .foregroundColor(AppColors.textPrimary)
                                    
                                    LazyVGrid(columns: [
                                        GridItem(.flexible()),
                                        GridItem(.flexible())
                                    ], spacing: 12) {
                                        ForEach(viewModel.wardrobeItems) { item in
                                            ItemSelectionCard(
                                                item: item,
                                                isSelected: selectedItems.contains(item.id)
                                            ) {
                                                if selectedItems.contains(item.id) {
                                                    selectedItems.remove(item.id)
                                                } else {
                                                    selectedItems.insert(item.id)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationTitle("New Outfit")
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
                        saveOutfit()
                    }
                    .foregroundColor(isFormValid ? AppColors.primary : AppColors.textSecondary)
                    .disabled(!isFormValid)
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .onAppear {
            if let defaultName = defaultName, !defaultName.isEmpty {
                name = defaultName
            }
        }
    }
    
    private func saveOutfit() {
        let selectedWardrobeItems = viewModel.wardrobeItems.filter { selectedItems.contains($0.id) }
        var imageName: String? = nil
        if let image = selectedImage, let savedName = ImageStorage.saveOutfitImage(image) {
            imageName = savedName
        }
        
        let outfit = Outfit(
            name: name,
            items: selectedWardrobeItems,
            imageName: imageName,
            category: category.isEmpty ? nil : category
        )
        
        viewModel.addOutfit(outfit)
        dismiss()
    }
}

struct ItemSelectionCard: View {
    let item: WardrobeItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 0)
                    .fill(isSelected ? AppColors.primary.opacity(0.2) : AppColors.cardBackground)
                    .frame(height: 60)
                    .overlay(
                        ItemPhotoView(imageName: item.imageName, placeholderIcon: "tshirt.fill", placeholderSize: 20, cornerRadius: 8)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(isSelected ? AppColors.primary : Color.clear, lineWidth: 4)
                    )
                    .clipped()
                
                VStack(spacing: 2) {
                    Text(item.name)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(1)
                    
                    Text(item.category)
                        .font(.ubuntu(10))
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(1)
                }
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
                    .shadow(color: AppColors.shadow, radius: 4, x: 0, y: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AddOutfitView()
        .environmentObject(WardrobeViewModel())
}
