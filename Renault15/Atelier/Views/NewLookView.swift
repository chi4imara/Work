import SwiftUI
import PhotosUI

struct NewLookView: View {
    @ObservedObject var viewModel: HairstyleViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoData: Data?
    @State private var selectedHairstyles: Set<UUID> = []
    
    private var isFormValid: Bool {
        !name.isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.primaryGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        photoPickerSection
                        
                        CustomTextField(
                            title: "Look Name",
                            text: $name,
                            placeholder: "Enter look name"
                        )
                        
                        hairstylesSelectionSection
                        
                        actionButtonsSection
                    }
                    .padding(.horizontal, AppDimensions.screenPadding)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("New Look")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryYellow)
                }
            }
            .preferredColorScheme(.dark)
        }
        .onChange(of: selectedPhoto) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    photoData = data
                }
            }
        }
    }
    
    private var photoPickerSection: some View {
        VStack(spacing: 12) {
            Text("Look Photo")
                .font(AppFonts.subtitle)
                .foregroundColor(AppColors.primaryWhite)
            
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                    .fill(AppColors.primaryWhite.opacity(0.2))
                    .frame(height: 150)
                    .overlay(
                        Group {
                            if let photoData = photoData, let uiImage = UIImage(data: photoData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 150)
                                    .clipped()
                                    .cornerRadius(AppDimensions.cornerRadius)
                            } else {
                                VStack(spacing: 8) {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(AppColors.primaryYellow)
                                    Text("Select Photo")
                                        .font(AppFonts.body)
                                        .foregroundColor(AppColors.primaryWhite)
                                }
                            }
                        }
                    )
            }
        }
    }
    
    private var hairstylesSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select Hairstyles (Optional)")
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryWhite)
            
            if viewModel.hairstyles.isEmpty {
                Text("No hairstyles available. Create some hairstyles first.")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.primaryWhite.opacity(0.7))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppColors.primaryWhite.opacity(0.1))
                    .cornerRadius(AppDimensions.cornerRadius)
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(viewModel.hairstyles) { hairstyle in
                        SelectableHairstyleCard(
                            hairstyle: hairstyle,
                            isSelected: selectedHairstyles.contains(hairstyle.id)
                        ) {
                            if selectedHairstyles.contains(hairstyle.id) {
                                selectedHairstyles.remove(hairstyle.id)
                            } else {
                                selectedHairstyles.insert(hairstyle.id)
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: 16) {
            Button {
                saveLook()
            } label: {
                Text("Save Look")
                    .font(AppFonts.button)
                    .foregroundColor(isFormValid ? AppColors.darkBlue : AppColors.darkGray)
                    .frame(maxWidth: .infinity)
                    .frame(height: AppDimensions.buttonHeight)
                    .background(isFormValid ? AppColors.primaryYellow : AppColors.lightGray)
                    .cornerRadius(AppDimensions.cornerRadius)
            }
            .disabled(!isFormValid)
            
            Button("Cancel") {
                dismiss()
            }
            .font(AppFonts.body)
            .foregroundColor(AppColors.primaryWhite.opacity(0.8))
        }
        .padding(.bottom, 30)
    }
    
    private func saveLook() {
        let selectedHairstyleObjects = viewModel.hairstyles.filter { selectedHairstyles.contains($0.id) }
        
        let look = Look(
            name: name,
            photo: photoData,
            hairstyles: selectedHairstyleObjects
        )
        
        viewModel.addLook(look)
        dismiss()
    }
}

struct SelectableHairstyleCard: View {
    let hairstyle: Hairstyle
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.primaryWhite.opacity(isSelected ? 0.3 : 0.1))
                .frame(height: 80)
                .overlay(
                    VStack(spacing: 6) {
                        HStack {
                            Text(hairstyle.name)
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.primaryWhite)
                                .lineLimit(2)
                            
                            Spacer()
                            
                            if isSelected {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(AppColors.primaryYellow)
                            }
                        }
                        
                        HStack {
                            Text(hairstyle.category.displayName)
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.primaryYellow)
                            
                            Spacer()
                        }
                    }
                    .padding(8)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(isSelected ? AppColors.primaryYellow : Color.clear, lineWidth: 2)
                )
        }
    }
}

#Preview {
    NewLookView(viewModel: HairstyleViewModel())
}
