import SwiftUI

struct ColorOption: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
}

struct ColorPalette {
    static let commonColors: [ColorOption] = [
        ColorOption(name: "Black", color: .black),
        ColorOption(name: "White", color: .white),
        ColorOption(name: "Beige", color: Color(red: 0.96, green: 0.96, blue: 0.86)),
        ColorOption(name: "Brown", color: Color(red: 0.59, green: 0.29, blue: 0.0)),
        ColorOption(name: "Navy Blue", color: Color(red: 0.0, green: 0.13, blue: 0.28)),
        ColorOption(name: "Red", color: .red),
        ColorOption(name: "Pink", color: Color(red: 1.0, green: 0.75, blue: 0.8)),
        ColorOption(name: "Green", color: .green),
        ColorOption(name: "Blue", color: .blue),
        ColorOption(name: "Yellow", color: .yellow),
        ColorOption(name: "Gold", color: Color(red: 0.83, green: 0.69, blue: 0.22)),
        ColorOption(name: "Silver", color: Color(red: 0.75, green: 0.75, blue: 0.75)),
        ColorOption(name: "Gray", color: .gray),
        ColorOption(name: "Purple", color: .purple),
        ColorOption(name: "Orange", color: .orange),
        ColorOption(name: "Burgundy", color: Color(red: 0.5, green: 0.0, blue: 0.13)),
        ColorOption(name: "Cream", color: Color(red: 1.0, green: 0.99, blue: 0.82)),
        ColorOption(name: "Tan", color: Color(red: 0.82, green: 0.71, blue: 0.55)),
        ColorOption(name: "Olive", color: Color(red: 0.5, green: 0.5, blue: 0.0)),
        ColorOption(name: "Coral", color: Color(red: 1.0, green: 0.5, blue: 0.31))
    ]
    
    static func colorForName(_ name: String) -> Color? {
        return commonColors.first { $0.name.lowercased() == name.lowercased() }?.color
    }
    
    static func getColorSwatch(for colorName: String) -> Color {
        return colorForName(colorName) ?? Color.gray.opacity(0.3)
    }
}

struct ColorPickerView: View {
    @Binding var selectedColor: String
    let onColorSelected: (String) -> Void
    
    @State private var customColorText: String = ""
    @State private var searchText: String = ""
    
    private var filteredColors: [ColorOption] {
        if searchText.isEmpty {
            return ColorPalette.commonColors
        }
        return ColorPalette.commonColors.filter { 
            $0.name.localizedCaseInsensitiveContains(searchText) 
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Select Color")
                    .font(FontManager.ubuntu(.bold, size: 16))
                    .foregroundColor(AppColors.darkText)
                
                Spacer()
                
                if let selectedColorOption = ColorPalette.commonColors.first(where: { $0.name.lowercased() == selectedColor.lowercased() }) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(selectedColorOption.color)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                        
                        Text(selectedColor)
                            .font(FontManager.ubuntu(.medium, size: 14))
                            .foregroundColor(AppColors.darkText)
                    }
                }
            }
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.darkText.opacity(0.5))
                
                TextField("Search colors...", text: $searchText)
                    .font(FontManager.ubuntu(.regular, size: 14))
                    .foregroundColor(AppColors.darkText)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.darkText.opacity(0.5))
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(AppColors.cardBackground.opacity(0.5))
            .cornerRadius(8)
            
            if filteredColors.isEmpty {
                Text("No colors found")
                    .font(FontManager.ubuntu(.regular, size: 14))
                    .foregroundColor(AppColors.darkText.opacity(0.6))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 5), spacing: 12) {
                    ForEach(filteredColors) { colorOption in
                        ColorCircle(
                            colorOption: colorOption,
                            isSelected: selectedColor.lowercased() == colorOption.name.lowercased(),
                            onTap: {
                                selectedColor = colorOption.name
                                onColorSelected(colorOption.name)
                            }
                        )
                    }
                }
            }
            
            Divider()
                .padding(.vertical, 8)
            
            HStack(spacing: 12) {
                if let selectedColorOption = ColorPalette.commonColors.first(where: { $0.name.lowercased() == selectedColor.lowercased() }) {
                    Circle()
                        .fill(selectedColorOption.color)
                        .frame(width: 30, height: 30)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                }
                
                TextField("Or enter custom color...", text: $customColorText)
                    .font(FontManager.ubuntu(.regular, size: 14))
                    .foregroundColor(AppColors.darkText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(AppColors.cardBackground)
                    .cornerRadius(8)
                
                Button("Add") {
                    if !customColorText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        selectedColor = customColorText.trimmingCharacters(in: .whitespacesAndNewlines)
                        onColorSelected(selectedColor)
                        customColorText = ""
                    }
                }
                .font(FontManager.ubuntu(.medium, size: 14))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(AppColors.buttonPrimary)
                .cornerRadius(8)
            }
        }
    }
}

struct ColorCircle: View {
    let colorOption: ColorOption
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                ZStack {
                    Circle()
                        .fill(colorOption.color)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Circle()
                                .stroke(isSelected ? AppColors.primaryYellow : Color.clear, lineWidth: 3)
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.3), radius: 1, x: 0, y: 0)
                    }
                }
                
                Text(colorOption.name)
                    .font(FontManager.ubuntu(.regular, size: 10))
                    .foregroundColor(AppColors.darkText)
                    .lineLimit(1)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

