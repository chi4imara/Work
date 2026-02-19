import SwiftUI
import PhotosUI

struct AddAccessoryView: View {
    @EnvironmentObject private var accessoryViewModel: AccessoryViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var accessoryName = ""
    @State private var brand = ""
    @State private var price = ""
    @State private var selectedCategory: AccessoryCategory = .bag
    @State private var selectedStyle: AccessoryStyle = .casual
    @State private var selectedColors: Set<String> = []
    @State private var notes = ""
    @State private var selectedImage: PhotosPickerItem?
    @State private var showingCamera = false
    @State private var cameraImage: UIImage?
    @State private var loadedPhotoImage: UIImage?
    @State private var showingCameraUnavailableAlert = false
    
    private var hasImage: Bool {
        cameraImage != nil || loadedPhotoImage != nil
    }
    
    private var displayImage: UIImage? {
        cameraImage ?? loadedPhotoImage
    }
    
    let availableColors = ["Black", "White", "Brown", "Gold", "Silver", "Beige", "Pink", "Blue", "Red", "Green"]
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: AppConstants.sectionSpacing) {
                        imageSection
                        basicInfoSection
                        detailsSection
                        notesSection
                    }
                    .padding(.horizontal, AppConstants.cardPadding)
                }
            }
            .navigationTitle("Add Accessory")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.darkGray)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveAccessory()
                    }
                    .foregroundColor(AppColors.textBlue)
                    .font(.playfairDisplay(16, weight: .semibold))
                    .disabled(!isFormValid)
                    .opacity(isFormValid ? 1.0 : 0.6)
                }
            }
            .onChange(of: selectedImage) { newItem in
                guard let newItem = newItem else {
                    loadedPhotoImage = nil
                    return
                }
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        await MainActor.run {
                            loadedPhotoImage = uiImage
                        }
                    }
                }
            }
            .sheet(isPresented: $showingCamera) {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    CameraPickerView(image: $cameraImage)
                }
            }
            .alert("Camera Unavailable", isPresented: $showingCameraUnavailableAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Camera is not available on this device. Use Gallery to select a photo.")
            }
        }
    }
    
    private var imageSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Photo")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.textBlue)
            
            HStack(spacing: 16) {
                Group {
                    if let image = displayImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipped()
                            .cornerRadius(16)
                    } else {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.lightGray)
                            .frame(width: 120, height: 120)
                            .overlay(
                                VStack(spacing: 8) {
                                    Image(systemName: "photo.badge.plus")
                                        .font(.system(size: 30))
                                        .foregroundColor(AppColors.textBlue.opacity(0.6))
                                    Text("Add Photo")
                                        .font(.playfairDisplay(12, weight: .medium))
                                        .foregroundColor(AppColors.textBlue.opacity(0.6))
                                }
                            )
                    }
                }
                
                VStack(spacing: 12) {
                    Button(action: {
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            showingCamera = true
                        } else {
                            showingCameraUnavailableAlert = true
                        }
                    }) {
                        HStack {
                            Image(systemName: "camera")
                            Text("Camera")
                                .font(.playfairDisplay(14, weight: .medium))
                        }
                        .foregroundColor(AppColors.backgroundWhite)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(AppColors.textBlue)
                        .cornerRadius(12)
                    }
                    
                    PhotosPicker(selection: $selectedImage, matching: .images) {
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                            Text("Gallery")
                                .font(.playfairDisplay(14, weight: .medium))
                        }
                        .foregroundColor(AppColors.textBlue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(AppColors.backgroundWhite)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.textBlue, lineWidth: 1)
                        )
                    }
                }
            }
        }
        .padding(AppConstants.cardPadding)
        .background(AppColors.cardGradient)
        .cornerRadius(AppConstants.cornerRadius)
        .shadow(color: .gray.opacity(0.2), radius: AppConstants.shadowRadius, x: 0, y: 4)
    }
    
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Basic Information")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.textBlue)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Accessory Name")
                    .font(.playfairDisplay(14, weight: .semibold))
                    .foregroundColor(AppColors.textBlue)
                
                TextField("Enter accessory name", text: $accessoryName)
                    .font(.playfairDisplay(16, weight: .medium))
                    .padding(12)
                    .background(AppColors.backgroundWhite)
                    .cornerRadius(12)
            }
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Brand")
                        .font(.playfairDisplay(14, weight: .semibold))
                        .foregroundColor(AppColors.textBlue)
                    
                    TextField("Brand", text: $brand)
                        .font(.playfairDisplay(16, weight: .medium))
                        .padding(12)
                        .background(AppColors.backgroundWhite)
                        .cornerRadius(12)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Price")
                        .font(.playfairDisplay(14, weight: .semibold))
                        .foregroundColor(AppColors.textBlue)
                    
                    TextField("$0", text: $price)
                        .font(.playfairDisplay(16, weight: .medium))
                        .padding(12)
                        .background(AppColors.backgroundWhite)
                        .cornerRadius(12)
                        .keyboardType(.decimalPad)
                }
            }
        }
        .padding(AppConstants.cardPadding)
        .background(AppColors.cardGradient)
        .cornerRadius(AppConstants.cornerRadius)
        .shadow(color: .gray.opacity(0.2), radius: AppConstants.shadowRadius, x: 0, y: 4)
    }
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Details")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.textBlue)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Category")
                    .font(.playfairDisplay(14, weight: .semibold))
                    .foregroundColor(AppColors.textBlue)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(AccessoryCategory.allCases, id: \.self) { category in
                        Button(action: { selectedCategory = category }) {
                            HStack {
                                Image(systemName: category.icon)
                                    .font(.system(size: 16))
                                
                                Text(category.rawValue)
                                    .font(.playfairDisplay(14, weight: .medium))
                            }
                            .foregroundColor(selectedCategory == category ? AppColors.backgroundWhite : AppColors.textBlue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(selectedCategory == category ? AppColors.textBlue : AppColors.backgroundWhite)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColors.textBlue, lineWidth: selectedCategory == category ? 0 : 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Style")
                    .font(.playfairDisplay(14, weight: .semibold))
                    .foregroundColor(AppColors.textBlue)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(AccessoryStyle.allCases, id: \.self) { style in
                        Button(action: { selectedStyle = style }) {
                            Text(style.rawValue)
                                .font(.playfairDisplay(14, weight: .medium))
                                .foregroundColor(selectedStyle == style ? AppColors.backgroundWhite : style.color)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(selectedStyle == style ? style.color : style.color.opacity(0.1))
                                .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Colors")
                    .font(.playfairDisplay(14, weight: .semibold))
                    .foregroundColor(AppColors.textBlue)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
                    ForEach(availableColors, id: \.self) { color in
                        Button(action: {
                            if selectedColors.contains(color) {
                                selectedColors.remove(color)
                            } else {
                                selectedColors.insert(color)
                            }
                        }) {
                            VStack(spacing: 4) {
                                Circle()
                                    .fill(colorForName(color))
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        Circle()
                                            .stroke(AppColors.textBlue, lineWidth: selectedColors.contains(color) ? 3 : 1)
                                    )
                                
                                Text(color)
                                    .font(.playfairDisplay(8, weight: .medium))
                                    .foregroundColor(AppColors.textBlue)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .padding(AppConstants.cardPadding)
        .background(AppColors.cardGradient)
        .cornerRadius(AppConstants.cornerRadius)
        .shadow(color: .gray.opacity(0.2), radius: AppConstants.shadowRadius, x: 0, y: 4)
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Notes")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.textBlue)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Additional Notes (Optional)")
                    .font(.playfairDisplay(14, weight: .semibold))
                    .foregroundColor(AppColors.textBlue)
                
                TextField("Styling tips, occasions, or other notes...", text: $notes, axis: .vertical)
                    .font(.playfairDisplay(14, weight: .medium))
                    .padding(12)
                    .background(AppColors.backgroundWhite)
                    .cornerRadius(12)
                    .lineLimit(3...6)
            }
        }
        .padding(AppConstants.cardPadding)
        .background(AppColors.cardGradient)
        .cornerRadius(AppConstants.cornerRadius)
        .shadow(color: .gray.opacity(0.2), radius: AppConstants.shadowRadius, x: 0, y: 4)
    }
    
    private var isFormValid: Bool {
        !accessoryName.isEmpty && !brand.isEmpty && !price.isEmpty
    }
    
    private func colorForName(_ name: String) -> Color {
        switch name.lowercased() {
        case "black": return .black
        case "white": return .white
        case "brown": return .brown
        case "gold": return .yellow
        case "silver": return .gray
        case "beige": return Color(red: 0.96, green: 0.96, blue: 0.86)
        case "pink": return .pink
        case "blue": return .blue
        case "red": return .red
        case "green": return .green
        default: return .gray
        }
    }
    
    private func saveAccessory() {
        let priceValue = Double(price.replacingOccurrences(of: ",", with: ".")) ?? 0
        let newAccessory = Accessory(
            name: accessoryName,
            brand: brand,
            category: selectedCategory,
            price: priceValue,
            imageURL: hasImage ? "custom" : "",
            colors: Array(selectedColors),
            style: selectedStyle,
            description: notes,
            isFavorite: false
        )
        if let image = displayImage {
            ImageStorage.save(image, for: newAccessory.id)
        }
        accessoryViewModel.addAccessory(newAccessory)
        dismiss()
    }
}

#Preview {
    AddAccessoryView()
        .environmentObject(AccessoryViewModel())
}
