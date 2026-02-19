import SwiftUI
import PhotosUI

struct AddEditJewelryView: View {
    @ObservedObject var jewelryStore: JewelryStore
    @Environment(\.dismiss) private var dismiss
    
    let editingJewelry: Jewelry?
    
    @State private var name: String = ""
    @State private var selectedType: JewelryType = .earrings
    @State private var suitableFor: String = ""
    @State private var notes: String = ""
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageName: String?
    @State private var loadedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var isProcessingImage = false
    
    init(jewelryStore: JewelryStore, editingJewelry: Jewelry? = nil) {
        self.jewelryStore = jewelryStore
        self.editingJewelry = editingJewelry
        
        if let jewelry = editingJewelry {
            _name = State(initialValue: jewelry.name)
            _selectedType = State(initialValue: jewelry.type)
            _suitableFor = State(initialValue: jewelry.suitableFor)
            _notes = State(initialValue: jewelry.notes)
            _imageName = State(initialValue: jewelry.imageName)
        }
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        PhotoSection(
                            imageName: $imageName,
                            loadedImage: $loadedImage,
                            isProcessingImage: $isProcessingImage,
                            onImageTap: {
                                showingImagePicker = true
                            }
                        )
                        
                        VStack(spacing: 20) {
                            CustomTextField(
                                title: "Name",
                                text: $name,
                                placeholder: "Enter jewelry name"
                            )
                            
                            TypePickerSection(selectedType: $selectedType)
                            
                            CustomTextField(
                                title: "Suitable for",
                                text: $suitableFor,
                                placeholder: "e.g., office, evening, casual"
                            )
                            
                            CustomTextEditor(
                                title: "Notes (Optional)",
                                text: $notes,
                                placeholder: "Add any additional notes..."
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle(editingJewelry == nil ? "New Jewelry" : "Edit Jewelry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveJewelry()
                    }
                    .foregroundColor(isFormValid ? ColorTheme.accentYellow : ColorTheme.secondaryText)
                    .disabled(!isFormValid)
                }
            }
            .preferredColorScheme(.dark)
        }
        .photosPicker(isPresented: $showingImagePicker, selection: $selectedImage, matching: .images)
        .onChange(of: selectedImage) { newValue in
            guard let newValue = newValue else { return }
            isProcessingImage = true
            
            Task {
                if let data = try? await newValue.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        ImageManager.shared.processImageThroughTinyPNG(uiImage) { processedImage in
                            if let processedImage = processedImage {
                                let newImageName = "jewelry_\(UUID().uuidString)"
                                if ImageManager.shared.saveImage(processedImage, withName: newImageName) != nil {
                                    self.imageName = newImageName
                                    self.loadedImage = processedImage
                                }
                            }
                            self.isProcessingImage = false
                        }
                    }
                } else {
                    await MainActor.run {
                        isProcessingImage = false
                    }
                }
            }
        }
    }
    
    private func saveJewelry() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let editingJewelry = editingJewelry {
            if let oldImageName = editingJewelry.imageName, oldImageName != imageName {
                ImageManager.shared.deleteImage(named: oldImageName)
            }
            
            var updatedJewelry = editingJewelry
            updatedJewelry.name = trimmedName
            updatedJewelry.type = selectedType
            updatedJewelry.suitableFor = suitableFor
            updatedJewelry.notes = notes
            updatedJewelry.imageName = imageName
            
            jewelryStore.updateJewelry(updatedJewelry)
        } else {
            let newJewelry = Jewelry(
                name: trimmedName,
                type: selectedType,
                suitableFor: suitableFor,
                notes: notes,
                imageName: imageName
            )
            
            jewelryStore.addJewelry(newJewelry)
        }
        
        dismiss()
    }
}

struct PhotoSection: View {
    @Binding var imageName: String?
    @Binding var loadedImage: UIImage?
    @Binding var isProcessingImage: Bool
    let onImageTap: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Photo")
                .font(.lumierepolis(16, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            
            Button(action: onImageTap) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(ColorTheme.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(ColorTheme.cardBorder, lineWidth: 1)
                        )
                        .frame(width: 120, height: 120)
                    
                    if isProcessingImage {
                        ProgressView()
                            .tint(ColorTheme.accentYellow)
                    } else if let loadedImage = loadedImage {
                        Image(uiImage: loadedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    } else if let imageName = imageName, !imageName.isEmpty {
                        AsyncJewelryImage(imageName: imageName, placeholder: "photo", size: CGSize(width: 120, height: 120))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "camera")
                                .font(.system(size: 30))
                                .foregroundColor(ColorTheme.secondaryText)
                            Text("Add Photo")
                                .font(.lumierepolis(12))
                                .foregroundColor(ColorTheme.secondaryText)
                        }
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .onAppear {
            if let imageName = imageName, !imageName.isEmpty, loadedImage == nil {
                loadedImage = ImageManager.shared.loadImage(named: imageName)
            }
        }
    }
}

struct TypePickerSection: View {
    @Binding var selectedType: JewelryType
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Type")
                .font(.lumierepolis(16, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(JewelryType.allCases, id: \.self) { type in
                    TypeButton(
                        type: type,
                        isSelected: selectedType == type,
                        action: {
                            selectedType = type
                        }
                    )
                }
            }
        }
    }
}

struct TypeButton: View {
    let type: JewelryType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: type.icon)
                    .font(.system(size: 16))
                
                Text(type.rawValue)
                    .font(.lumierepolis(14, weight: .regular))
            }
            .foregroundColor(isSelected ? ColorTheme.buttonText : ColorTheme.primaryText)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? ColorTheme.buttonPrimary : ColorTheme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? ColorTheme.buttonPrimary : ColorTheme.cardBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.lumierepolis(16, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField(placeholder, text: $text)
                .font(.lumierepolis(16))
                .foregroundColor(ColorTheme.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorTheme.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(ColorTheme.cardBorder, lineWidth: 1)
                        )
                )
        }
    }
}

struct CustomTextEditor: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.lumierepolis(16, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.lumierepolis(16))
                        .foregroundColor(ColorTheme.secondaryText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                }
                
                TextEditor(text: $text)
                    .font(.lumierepolis(16))
                    .foregroundColor(ColorTheme.primaryText)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 100)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(ColorTheme.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(ColorTheme.cardBorder, lineWidth: 1)
                            )
                        
                    )
            }
        }
    }
}

#Preview {
    AddEditJewelryView(jewelryStore: JewelryStore())
}
