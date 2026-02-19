import SwiftUI

struct EditOutfitView: View {
    @EnvironmentObject var outfitViewModel: OutfitViewModel
    @Environment(\.dismiss) private var dismiss
    
    let outfit: Outfit
    
    @State private var name: String
    @State private var description: String
    @State private var selectedCategory: OutfitCategory
    @State private var isFavorite: Bool
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var showingActionSheet = false
    
    init(outfit: Outfit) {
        self.outfit = outfit
        self._name = State(initialValue: outfit.name)
        self._description = State(initialValue: outfit.description)
        self._selectedCategory = State(initialValue: outfit.category)
        self._isFavorite = State(initialValue: outfit.isFavorite)
        self._selectedImage = State(initialValue: outfit.image)
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && selectedImage != nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            Text("Photo")
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
                                            
                                            Text("Tap to change photo")
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
                                Text("In favorites")
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
                        
                        Button(action: saveChanges) {
                            Text("Save Changes")
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
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Edit Outfit")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.textPrimary)
                    .font(.lumierepolis(16))
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
    
    private func saveChanges() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
        
        var updatedOutfit = outfit
        updatedOutfit.name = trimmedName
        updatedOutfit.description = trimmedDescription
        updatedOutfit.category = selectedCategory
        updatedOutfit.isFavorite = isFavorite
        updatedOutfit.imageData = imageData
        
        outfitViewModel.updateOutfit(updatedOutfit)
        dismiss()
    }
}

#Preview {
    EditOutfitView(outfit: Outfit(
        name: "Summer Casual",
        description: "Perfect for hot summer days",
        category: .casual,
        isFavorite: true
    ))
    .environmentObject(OutfitViewModel())
}
