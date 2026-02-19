import SwiftUI
import UIKit

struct AddBagView: View {
    @EnvironmentObject private var bagViewModel: BagViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var bagName = ""
    @State private var brandName = ""
    @State private var selectedCategory: BagCategory = .tote
    @State private var selectedSize: BagSize = .medium
    @State private var selectedStyle: BagStyle = .casual
    @State private var selectedColor = "Black"
    @State private var price = ""
    @State private var bagDescription = ""
    @State private var notes = ""
    @State private var showingImagePicker = false
    @State private var showingImageSourceActionSheet = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImages: [String] = []
    @State private var showingColorPicker = false
    
    private let availableColors = ["Black", "White", "Brown", "Navy", "Red", "Blue", "Green", "Pink", "Gray", "Beige", "Gold", "Silver"]
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundView
                
                ScrollView {
                    VStack(spacing: 24) {
                        photoSection
                        
                        basicInfoSection
                        
                        detailsSection
                        
                        descriptionSection
                        
                        notesSection
                        
                        saveButtonSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Add New Bag")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.primaryText)
                }
            }
            .preferredColorScheme(.dark)
        }
        .confirmationDialog("Add Photo", isPresented: $showingImageSourceActionSheet, titleVisibility: .visible) {
            Button("Photo Library") {
                imagePickerSourceType = .photoLibrary
                showingImagePicker = true
            }
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button("Camera") {
                    imagePickerSourceType = .camera
                    showingImagePicker = true
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Choose a photo from your library or take a new one")
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(
                sourceType: imagePickerSourceType,
                onImagePicked: { image in
                    if let filename = BagPhotoStorage.saveImage(image) {
                        selectedImages.append(filename)
                    }
                    showingImagePicker = false
                },
                onCancel: { showingImagePicker = false }
            )
        }
        .sheet(isPresented: $showingColorPicker) {
            ColorPickerView(selectedColor: $selectedColor, availableColors: availableColors)
        }
    }
    
    private var backgroundView: some View {
        ZStack {
            LinearGradient(
                colors: [Color.theme.gradientStart, Color.theme.gradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            GridPattern()
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        }
    }
    
    private var photoSection: some View {
        AddBagSectionCard(title: "Photos") {
            VStack(spacing: 16) {
                if selectedImages.isEmpty {
                    Button(action: { showingImageSourceActionSheet = true }) {
                        VStack(spacing: 12) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 40))
                                .foregroundColor(Color.theme.accentYellow)
                            
                            Text("Add Photos")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(Color.theme.primaryText)
                            
                            Text("Tap to add photos of your bag")
                                .font(.ubuntu(12))
                                .foregroundColor(Color.theme.secondaryText)
                        }
                        .frame(height: 120)
                        .frame(maxWidth: .infinity)
                        .background(Color.theme.cardBackground)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.theme.cardBorder, style: StrokeStyle(lineWidth: 2, dash: [5]))
                        )
                    }
                } else {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 8) {
                        ForEach(selectedImages, id: \.self) { imagePath in
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.theme.cardBackground)
                                    .frame(height: 80)
                                
                                BagPhotoThumbnailView(filename: imagePath)
                                    .frame(height: 80)
                                    .clipped()
                                    .cornerRadius(8)
                                
                                VStack {
                                    HStack {
                                        Spacer()
                                        Button(action: { removeImage(imagePath) }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(Color.red)
                                                .background(Color.white, in: Circle())
                                        }
                                        .padding(4)
                                    }
                                    Spacer()
                                }
                            }
                        }
                        
                        Button(action: { showingImageSourceActionSheet = true }) {
                            VStack(spacing: 4) {
                                Image(systemName: "plus")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color.theme.accentYellow)
                                
                                Text("Add")
                                    .font(.ubuntu(10))
                                    .foregroundColor(Color.theme.secondaryText)
                            }
                            .frame(height: 80)
                            .frame(maxWidth: .infinity)
                            .background(Color.theme.cardBackground)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.theme.cardBorder, style: StrokeStyle(lineWidth: 1, dash: [3]))
                            )
                        }
                    }
                }
            }
        }
    }
    
    private var basicInfoSection: some View {
        AddBagSectionCard(title: "Basic Information") {
            VStack(spacing: 16) {
                CustomTextField(title: "Bag Name", text: $bagName, placeholder: "Enter bag name")
                CustomTextField(title: "Brand", text: $brandName, placeholder: "Enter brand name")
                CustomTextField(title: "Price", text: $price, placeholder: "0.00", keyboardType: .decimalPad)
            }
        }
    }
    
    private var detailsSection: some View {
        AddBagSectionCard(title: "Details") {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Category")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Menu {
                        ForEach(BagCategory.allCases, id: \.self) { category in
                            Button(category.rawValue) {
                                selectedCategory = category
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedCategory.rawValue)
                                .font(.ubuntu(14))
                                .foregroundColor(Color.theme.primaryText)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .foregroundColor(Color.theme.secondaryText)
                        }
                        .padding(12)
                        .background(Color.theme.cardBackground)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.theme.cardBorder, lineWidth: 1)
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Size")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(Color.theme.primaryText)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 8) {
                        ForEach(BagSize.allCases, id: \.self) { size in
                            Button(action: { selectedSize = size }) {
                                Text(size.rawValue)
                                    .font(.ubuntu(12, weight: .medium))
                                    .foregroundColor(selectedSize == size ? Color.theme.primaryText : Color.theme.secondaryText)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity)
                                    .background(selectedSize == size ? Color.theme.accentYellow : Color.theme.cardBackground)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(selectedSize == size ? Color.theme.accentYellow : Color.theme.cardBorder, lineWidth: 1)
                                    )
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Style")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(Color.theme.primaryText)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 8) {
                        ForEach(BagStyle.allCases, id: \.self) { style in
                            Button(action: { selectedStyle = style }) {
                                Text(style.rawValue)
                                    .font(.ubuntu(12, weight: .medium))
                                    .foregroundColor(selectedStyle == style ? Color.theme.primaryText : Color.theme.secondaryText)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity)
                                    .background(selectedStyle == style ? Color.theme.accentYellow : Color.theme.cardBackground)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(selectedStyle == style ? Color.theme.accentYellow : Color.theme.cardBorder, lineWidth: 1)
                                    )
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Color")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Button(action: { showingColorPicker = true }) {
                        HStack {
                            Circle()
                                .fill(colorFromString(selectedColor))
                                .frame(width: 20, height: 20)
                                .overlay(
                                    Circle()
                                        .stroke(Color.theme.cardBorder, lineWidth: 1)
                                )
                            
                            Text(selectedColor)
                                .font(.ubuntu(14))
                                .foregroundColor(Color.theme.primaryText)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .foregroundColor(Color.theme.secondaryText)
                        }
                        .padding(12)
                        .background(Color.theme.cardBackground)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.theme.cardBorder, lineWidth: 1)
                        )
                    }
                }
            }
        }
    }
    
    private var descriptionSection: some View {
        AddBagSectionCard(title: "Description") {
            VStack(alignment: .leading, spacing: 8) {
                Text("Tell us about this bag")
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                
                TextField("Perfect for everyday use, spacious interior...", text: $bagDescription, axis: .vertical)
                    .font(.ubuntu(14))
                    .foregroundColor(Color.theme.primaryText)
                    .padding(12)
                    .background(Color.theme.cardBackground)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.theme.cardBorder, lineWidth: 1)
                    )
                    .lineLimit(3...6)
            }
        }
    }
    
    private var notesSection: some View {
        AddBagSectionCard(title: "Personal Notes") {
            VStack(alignment: .leading, spacing: 8) {
                Text("Your thoughts and recommendations")
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                
                TextField("Great with jeans, perfect for work...", text: $notes, axis: .vertical)
                    .font(.ubuntu(14))
                    .foregroundColor(Color.theme.primaryText)
                    .padding(12)
                    .background(Color.theme.cardBackground)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.theme.cardBorder, lineWidth: 1)
                    )
                    .lineLimit(3...6)
            }
        }
    }
    
    private var saveButtonSection: some View {
        Button(action: saveBag) {
            Text("Save Bag")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(isFormValid ? Color.theme.primaryButton : Color.theme.disabledButton)
                .cornerRadius(25)
        }
        .disabled(!isFormValid)
    }
    
    private var isFormValid: Bool {
        !bagName.isEmpty && !brandName.isEmpty && !price.isEmpty
    }
    
    private func removeImage(_ imagePath: String) {
        selectedImages.removeAll { $0 == imagePath }
        BagPhotoStorage.removeImage(filename: imagePath)
    }
    
    private func saveBag() {
        let priceValue = Double(price.replacingOccurrences(of: ",", with: ".")) ?? 0
        let descriptionText = bagDescription.isEmpty ? notes : bagDescription
        let bag = Bag(
            name: bagName,
            brand: brandName,
            category: selectedCategory,
            size: selectedSize,
            price: priceValue,
            imageURL: selectedImages.first ?? "",
            color: selectedColor,
            style: selectedStyle,
            isFavorite: false,
            description: descriptionText.isEmpty ? "No description" : descriptionText
        )
        bagViewModel.addBag(bag)
        dismiss()
    }
    
    private func colorFromString(_ colorName: String) -> Color {
        switch colorName.lowercased() {
        case "black": return .black
        case "white": return .white
        case "brown": return .brown
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "pink": return .pink
        case "gray": return .gray
        case "navy": return Color(red: 0.0, green: 0.0, blue: 0.5)
        case "beige": return Color(red: 0.96, green: 0.96, blue: 0.86)
        case "gold": return Color(red: 1.0, green: 0.8, blue: 0.0)
        case "silver": return Color(red: 0.75, green: 0.75, blue: 0.75)
        default: return Color.theme.accentYellow
        }
    }
}

struct BagPhotoThumbnailView: View {
    let filename: String
    
    var body: some View {
        Group {
            if let image = BagPhotoStorage.loadImage(filename: filename) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.theme.cardBackground)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(Color.theme.accentYellow)
                    )
            }
        }
    }
}

struct AddBagSectionCard<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            content
        }
        .padding(16)
        .background(Color.theme.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
        )
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(Color.theme.primaryText)
            
            TextField(placeholder, text: $text)
                .font(.ubuntu(14))
                .foregroundColor(Color.theme.primaryText)
                .padding(12)
                .background(Color.theme.cardBackground)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.theme.cardBorder, lineWidth: 1)
                )
                .keyboardType(keyboardType)
        }
    }
}

struct ColorPickerView: View {
    @Binding var selectedColor: String
    let availableColors: [String]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.theme.gradientStart, Color.theme.gradientEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(availableColors, id: \.self) { color in
                            Button(action: {
                                selectedColor = color
                                dismiss()
                            }) {
                                VStack(spacing: 8) {
                                    Circle()
                                        .fill(colorFromString(color))
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Circle()
                                                .stroke(selectedColor == color ? Color.theme.accentYellow : Color.theme.cardBorder, lineWidth: selectedColor == color ? 3 : 1)
                                        )
                                    
                                    Text(color)
                                        .font(.ubuntu(12, weight: .medium))
                                        .foregroundColor(Color.theme.primaryText)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    
                    Spacer()
                }
            }
            .navigationTitle("Select Color")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.accentYellow)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private func colorFromString(_ colorName: String) -> Color {
        switch colorName.lowercased() {
        case "black": return .black
        case "white": return .white
        case "brown": return .brown
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "pink": return .pink
        case "gray": return .gray
        case "navy": return Color(red: 0.0, green: 0.0, blue: 0.5)
        case "beige": return Color(red: 0.96, green: 0.96, blue: 0.86)
        case "gold": return Color(red: 1.0, green: 0.8, blue: 0.0)
        case "silver": return Color(red: 0.75, green: 0.75, blue: 0.75)
        default: return Color.theme.accentYellow
        }
    }
}

#Preview {
    AddBagView()
        .environmentObject(BagViewModel())
}
