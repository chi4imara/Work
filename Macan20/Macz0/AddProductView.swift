import SwiftUI

struct AddProductView: View {
    @ObservedObject var viewModel: CosmeticViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedTab: Int
    
    @State private var name = ""
    @State private var selectedType = ProductType.lipstick
    @State private var brand = ""
    @State private var color = ""
    @State private var selectedLabel = ProductLabel.none
    @State private var comment = ""
    
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("New Product")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(ColorTheme.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name *")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorTheme.white)
                            
                            TextField("Product name", text: $name)
                                .font(.ubuntu(16))
                                .foregroundColor(ColorTheme.white)
                                .padding(16)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(12)
                                .accentColor(ColorTheme.lightBlue)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Type")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorTheme.white)
                            
                            Picker("Type", selection: $selectedType) {
                                ForEach(ProductType.allCases, id: \.self) { type in
                                    Text(type.displayName)
                                        .tag(type)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .colorMultiply(ColorTheme.lightBlue)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Brand")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorTheme.white)
                            
                            TextField("Brand name", text: $brand)
                                .font(.ubuntu(16))
                                .foregroundColor(ColorTheme.white)
                                .padding(16)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(12)
                                .accentColor(ColorTheme.lightBlue)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Color Description")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorTheme.white)
                            
                            TextField("e.g., Warm coral with pink undertones", text: $color)
                                .font(.ubuntu(16))
                                .foregroundColor(ColorTheme.white)
                                .padding(16)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(12)
                                .accentColor(ColorTheme.lightBlue)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Label")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorTheme.white)
                            
                            HStack(spacing: 16) {
                                ForEach([ProductLabel.none, ProductLabel.favorite, ProductLabel.duplicate], id: \.self) { label in
                                    Button(action: { selectedLabel = label }) {
                                        HStack(spacing: 8) {
                                            if !label.emoji.isEmpty {
                                                Text(label.emoji)
                                                    .font(.system(size: 16))
                                            }
                                            Text(label.displayName)
                                                .font(.ubuntu(14, weight: .medium))
                                        }
                                        .foregroundColor(selectedLabel == label ? ColorTheme.white : ColorTheme.textSecondary)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(selectedLabel == label ? ColorTheme.lightBlue : ColorTheme.cardBackground)
                                        .cornerRadius(20)
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorTheme.white)
                            
                            TextField("Additional notes", text: $comment, axis: .vertical)
                                .font(.ubuntu(16))
                                .foregroundColor(ColorTheme.white)
                                .padding(16)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(12)
                                .accentColor(ColorTheme.lightBlue)
                                .lineLimit(3...6)
                        }
                        
                        Button {
                            saveProduct()
                        } label: {
                            HStack {
                                Text("Save")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(ColorTheme.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(ColorTheme.buttonGradient)
                            .cornerRadius(16)
                            .shadow(color: ColorTheme.lightBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .disabled(!canSave)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
    }
    
    private func saveProduct() {
        let product = CosmeticProduct(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            type: selectedType,
            brand: brand.trimmingCharacters(in: .whitespacesAndNewlines),
            color: color.trimmingCharacters(in: .whitespacesAndNewlines),
            label: selectedLabel,
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addProduct(product)
        presentationMode.wrappedValue.dismiss()
        
        withAnimation {
            selectedTab = 0
            
            name = ""
            selectedType = ProductType.lipstick
            brand = ""
            color = ""
            selectedLabel = ProductLabel.none
            comment = ""
        }
    }
}

