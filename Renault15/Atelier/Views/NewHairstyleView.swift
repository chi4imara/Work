import SwiftUI
import PhotosUI

struct NewHairstyleView: View {
    @ObservedObject var viewModel: HairstyleViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var selectedCategory = HairstyleCategory.cuts
    @State private var selectedLength = HairLength.medium
    @State private var hairColor = ""
    @State private var comment = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoData: Data?
    
    private var isFormValid: Bool {
        !name.isEmpty && !hairColor.isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.primaryGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        photoPickerSection
                        
                        formFieldsSection
                        
                        actionButtonsSection
                    }
                    .padding(.horizontal, AppDimensions.screenPadding)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("New Hairstyle")
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
            Text("Photo for Try-On")
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
    
    private var formFieldsSection: some View {
        VStack(spacing: 20) {
            CustomTextField(
                title: "Hairstyle Name",
                text: $name,
                placeholder: "Enter hairstyle name"
            )
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Category")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryWhite)
                
                Picker("Category", selection: $selectedCategory) {
                    ForEach(HairstyleCategory.allCases, id: \.self) { category in
                        Text(category.displayName).tag(category)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .background(AppColors.primaryWhite.opacity(0.1))
                .cornerRadius(AppDimensions.smallCornerRadius)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Hair Length")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryWhite)
                
                Picker("Hair Length", selection: $selectedLength) {
                    ForEach(HairLength.allCases, id: \.self) { length in
                        Text(length.displayName).tag(length)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .background(AppColors.primaryWhite.opacity(0.1))
                .cornerRadius(AppDimensions.smallCornerRadius)
            }
            
            CustomTextField(
                title: "Hair Color",
                text: $hairColor,
                placeholder: "Enter hair color"
            )
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Comment (Optional)")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryWhite)
                
                TextField("Add your thoughts...", text: $comment, axis: .vertical)
                    .lineLimit(3...6)
                    .padding()
                    .background(AppColors.primaryWhite.opacity(0.1))
                    .foregroundColor(AppColors.primaryWhite)
                    .cornerRadius(AppDimensions.cornerRadius)
            }
        }
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: 16) {
            Button {
                saveHairstyle()
            } label: {
                Text("Save Hairstyle")
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
    
    private func saveHairstyle() {
        let hairstyle = Hairstyle(
            name: name,
            category: selectedCategory,
            hairLength: selectedLength,
            hairColor: hairColor,
            photo: photoData,
            comment: comment
        )
        
        viewModel.addHairstyle(hairstyle)
        dismiss()
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryWhite)
            
            TextField(placeholder, text: $text)
                .padding()
                .background(AppColors.primaryWhite.opacity(0.1))
                .foregroundColor(AppColors.primaryWhite)
                .cornerRadius(AppDimensions.cornerRadius)
        }
    }
}

#Preview {
    NewHairstyleView(viewModel: HairstyleViewModel())
}
