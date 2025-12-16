import SwiftUI

struct AddEditBagView: View {
    @ObservedObject var viewModel: BagViewModel
    @Environment(\.dismiss) private var dismiss
    
    let editingBag: Bag?
    
    @State private var name: String = ""
    @State private var brand: String = ""
    @State private var selectedStyle: BagStyle = .everyday
    @State private var color: String = ""
    @State private var selectedFrequency: UsageFrequency = .sometimes
    @State private var comment: String = ""
    
    init(viewModel: BagViewModel, editingBag: Bag? = nil) {
        self.viewModel = viewModel
        self.editingBag = editingBag
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        ZStack {
                            Circle()
                                .fill(AppColors.primaryYellow.opacity(0.2))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "handbag.fill")
                                .font(.system(size: 40))
                                .foregroundColor(AppColors.primaryYellow)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            FormField(
                                title: "Bag Name",
                                text: $name,
                                placeholder: "e.g., Mini Tote"
                            )
                            
                            FormField(
                                title: "Brand",
                                text: $brand,
                                placeholder: "e.g., Celine, Zara, Dior"
                            )
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Style")
                                    .font(FontManager.ubuntu(.medium, size: 16))
                                    .foregroundColor(AppColors.primaryText)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                    ForEach(BagStyle.allCases) { style in
                                        StyleSelectionCard(
                                            style: style,
                                            isSelected: selectedStyle == style
                                        ) {
                                            selectedStyle = style
                                        }
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Color")
                                    .font(FontManager.ubuntu(.medium, size: 16))
                                    .foregroundColor(AppColors.primaryText)
                                
                                ColorPickerView(selectedColor: $color) { selectedColor in
                                    self.color = selectedColor
                                }
                                .padding(16)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.primaryYellow.opacity(0.3), lineWidth: 1)
                                )
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Usage Frequency")
                                    .font(FontManager.ubuntu(.medium, size: 16))
                                    .foregroundColor(AppColors.primaryText)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(UsageFrequency.allCases) { frequency in
                                            FrequencySelectionCard(
                                                frequency: frequency,
                                                isSelected: selectedFrequency == frequency
                                            ) {
                                                selectedFrequency = frequency
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                                .padding(.horizontal, -20)
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Comment")
                                    .font(FontManager.ubuntu(.medium, size: 16))
                                    .foregroundColor(AppColors.primaryText)
                                
                                TextEditor(text: $comment)
                                    .font(FontManager.ubuntu(.regular, size: 16))
                                    .foregroundColor(AppColors.darkText)
                                    .scrollContentBackground(.hidden)
                                    .frame(minHeight: 100)
                                    .padding(12)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.primaryYellow.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Button(action: saveBag) {
                            Text(editingBag == nil ? "Save Bag" : "Update Bag")
                                .font(FontManager.ubuntu(.medium, size: 18))
                                .foregroundColor(AppColors.primaryText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(AppColors.buttonPrimary)
                                .cornerRadius(28)
                        }
                        .disabled(!isFormValid)
                        .opacity(isFormValid ? 1.0 : 0.6)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle(editingBag == nil ? "New Bag" : "Edit Bag")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
            }
            .preferredColorScheme(.dark)
        }
        .onAppear {
            loadBagData()
        }
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !brand.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !color.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func loadBagData() {
        if let bag = editingBag {
            name = bag.name
            brand = bag.brand
            selectedStyle = bag.style
            color = bag.color
            selectedFrequency = bag.usageFrequency
            comment = bag.comment
        }
    }
    
    private func saveBag() {
        if let editingBag = editingBag {
            var updatedBag = editingBag
            updatedBag.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedBag.brand = brand.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedBag.style = selectedStyle
            updatedBag.color = color.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedBag.usageFrequency = selectedFrequency
            updatedBag.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
            viewModel.updateBag(updatedBag)
        } else {
            let bag = Bag(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                brand: brand.trimmingCharacters(in: .whitespacesAndNewlines),
                style: selectedStyle,
                color: color.trimmingCharacters(in: .whitespacesAndNewlines),
                usageFrequency: selectedFrequency,
                comment: comment.trimmingCharacters(in: .whitespacesAndNewlines),
                isFavorite: false,
                lastUsedDate: nil
            )
            viewModel.addBag(bag)
        }
        
        dismiss()
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(FontManager.ubuntu(.medium, size: 16))
                .foregroundColor(AppColors.primaryText)
            
            TextField(placeholder, text: $text)
                .font(FontManager.ubuntu(.regular, size: 16))
                .foregroundColor(AppColors.darkText)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.primaryYellow.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

struct StyleSelectionCard: View {
    let style: BagStyle
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: styleIcon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? AppColors.darkText : AppColors.primaryText)
                
                Text(style.displayName)
                    .font(FontManager.ubuntu(.medium, size: 14))
                    .foregroundColor(isSelected ? AppColors.darkText : AppColors.primaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppColors.primaryYellow : AppColors.buttonSecondary)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var styleIcon: String {
        switch style {
        case .everyday:
            return "bag"
        case .evening:
            return "sparkles"
        case .travel:
            return "airplane"
        case .other:
            return "questionmark.circle"
        }
    }
}

struct FrequencySelectionCard: View {
    let frequency: UsageFrequency
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(frequency.displayName)
                .font(FontManager.ubuntu(.medium, size: 14))
                .foregroundColor(isSelected ? AppColors.darkText : AppColors.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? AppColors.primaryYellow : AppColors.buttonSecondary)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AddEditBagView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditBagView(viewModel: BagViewModel())
    }
}
